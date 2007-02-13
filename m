Return-Path: <linux-kernel-owner+w=401wt.eu-S1750759AbXBMPqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750759AbXBMPqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXBMPqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:46:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:6247 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbXBMPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:46:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W0C6Z1yATrb2sHRGbf187dytDZ5GdNRYt7sgVs2krkFH4WdG2XdVI6dcGe0llgpybtgEUq90BI4x7XtJIXOIebHPcGVM/1+5tzlL2PtnFzDbKbnzokqbbWbpyCqie1eGbOSkD9t3chy66EZAq8uPIbRdlKs+DgI5STy6Z7gIbwk=
Message-ID: <d120d5000702130746k1a110efcice6630827510e96c@mail.gmail.com>
Date: Tue, 13 Feb 2007 10:46:03 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070213150019.4b4d4827@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu>
	 <20070213150019.4b4d4827@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > A syslet is executed opportunistically: i.e. the syslet subsystem
> > assumes that the syslet will not block, and it will switch to a
> > cachemiss kernel thread from the scheduler. This means that even a
>
> How is scheduler fairness maintained ? and what is done for resource
> accounting here ?
>
> > that the kernel fills and user-space clears. Waiting is done via the
> > sys_async_wait() system call. Completion can be supressed on a per-atom
>
> They should be selectable as well iff possible.
>
> > Open issues:
>
> Let me add some more
>
>        sys_setuid/gid/etc need to be synchronous only and not occur
> while other async syscalls are running in parallel to meet current kernel
> assumptions.
>
>        sys_exec and other security boundaries must be synchronous only
> and not allow async "spill over" (consider setuid async binary patching)
>
> >  - sys_fork() and sys_async_exec() should be filtered out from the
> >    syscalls that are allowed - first one only makes sense with ptregs,
>
> clone and vfork. async_vfork is a real mindbender actually.
>
> >    second one is a nice kernel recursion thing :) I didnt want to
> >    duplicate the sys_call_table though - maybe others have a better
> >    idea.
>
> What are the semantics of async sys_async_wait and async sys_async ?
>

Ooooohh. OpenVMS lives forever ;) Me likeee ;)

-- 
Dmitry
