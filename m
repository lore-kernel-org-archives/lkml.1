Return-Path: <linux-kernel-owner+w=401wt.eu-S1751373AbXBMWgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbXBMWgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXBMWgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:36:39 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:7185 "EHLO
	asav04.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbXBMWgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:36:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAGHM0UVKhRO4UGdsb2JhbACOUgEBKpMkAQEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Date: Tue, 13 Feb 2007 17:36:17 -0500
User-Agent: KMail/1.9.3
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20060529212109.GA2058@elte.hu> <d120d5000702130746k1a110efcice6630827510e96c@mail.gmail.com> <20070213203952.GA18130@elte.hu>
In-Reply-To: <20070213203952.GA18130@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131736.19612.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tuesday 13 February 2007 15:39, Ingo Molnar wrote:
> 
> * Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > > What are the semantics of async sys_async_wait and async sys_async ?
> > 
> > Ooooohh. OpenVMS lives forever ;) Me likeee ;)
> 
> hm, i dont know OpenVMS - but googled around a bit for 'VMS 
> asynchronous' and it gave me this:
> 
>   http://en.wikipedia.org/wiki/Asynchronous_system_trap
> 
> is AST what you mean? From a quick read AST seems to be a signal 
> mechanism a bit like Unix signals, extended to kernel-space as well - 
> while syslets are a different 'safe execution engine' kind of thing 
> centered around the execution of system calls.
> 

That is only one of ways of notifying userspace of system call completion
on OpenVMS. Pretty much every syscall there exists in 2 flavors - async
and sync, for example $QIO and $QIOW or $ENQ/$ENQW (actually -W flavor
is async call + $SYNCH to wait for completion). Once system service call
is completed the OS would raise a so-called event flag and may also
deliver an AST to the process. Application may either wait for an
event flag/set of event flags (EFN) or rely on AST to get notification.

-- 
Dmitry
