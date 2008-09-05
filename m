Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015AbYIELR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbYIELR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYIELRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:17:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:43319 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYIELRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-disposition:x-length:x-uid:content-type
         :content-transfer-encoding:message-id:from:sender;
        b=ICdQeB9FHwuMPWerUncltFAUal4KDC6x2fKc0GmReLFiqrzCWEqB9LfStutbFl033k
         QWiYid3zWpR5iKMRpj6G+4SCYAIpYFawd9xK1086OkJsj08j7Qo5aq5y0gjnMx2OWMhW
         M2ZfoSdmau+OcTc9zXruItKN9ZDR6nCvLH7Y8=
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [x86] fs, gs purpose & multicore prog
Date: Fri, 5 Sep 2008 13:17:10 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200809031109.45660.goretux@gmail.com> <48C011A6.2000609@goop.org>
In-Reply-To: <48C011A6.2000609@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2768
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200809051317.11116.goretux@gmail.com>
From: Eric Lacombe <tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your answers. I've some new questions now ;)

On Thursday 04 September 2008 18:49:42 Jeremy Fitzhardinge wrote:
> Eric Lacombe wrote:

> > - What is the FS and GS segments role inside the kernel ?
> > (I was thinking about thread local storage)
>
> In a 32-bit kernel %fs is the base of the per-cpu data area.  In a
> 64-bit kernel %gs points to the pda (processor data area).  The pda is a
> single structure, whereas per-cpu data is a section that per-cpu
> variables get put into.

So, %gs is not used in 32-bit kernel and %fs is not used in 64-bit kernel. Is 
it right ? Why there were different choices of design ?

>
> > - When I do a "mov %fs ..." instruction (in a module), it seems that %fs
> > is equal to 0 (idem for %gs). Are these registers not always filled ?
>
> On 32-bit they will always have a value, or you'll get a GPF.  On 64-bit
> the value of the selector doesn't matter because the MSRs are the real
> content.

ok, but what about the limits and access types?

>
> > - What is the purpose of MSR_FS_BASE and MSR_GS_BASE ?
> > (I thought they were filled with "gdt[fs_entry].base")
>
> On 64-bit, the GDT isn't large enough to hold a 64-bit offset, so it
> only stores the low 32-bits.  When you load a segment register with a
> selector, it picks up from the gdt.  If you want a full 64-bit offset,
> you need to write it to the msr.

Ok, I just saw that a 64-bit base in segment descriptor is only available for 
the system descriptor.

>
> > - My last question is about the kernel programation of multi-core (or
> > multiprocessor)
> > architecture. I don't see a lot of documentation about that on Internet.
> > Do you have some docs/urls about this topic.
> > Maybe someone can briefly explain how the execution flow are given to the
> > different cores.
>
> To the kernel they're all just cpus, and it runs tasks on them as
> usual.  There are a few tweaks in the scheduler to pay attention to the
> shared caches and so on.

Ok, but how does the kernel technically run tasks on different processor (or 
core)? My question was ambiguous, I was not assuming that I knew how 
multiprocessor works.

Thanks again.

	Eric

>
>     J
