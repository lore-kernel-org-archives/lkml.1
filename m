Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYIEXKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYIEXKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYIEXJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:09:58 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:39464 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYIEXJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:09:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Zterx2omugvZ4UFGaJApQuI3/97sHhJnpIOXchMIZT0kiLzZesql6nu518lCQV0wCg
         wVY6gWEavnLp5Hu7W8mHlmgUjEY5T6yNGvr6/yn10YKsD6VNgzyMiF0B2G1pt1OeeXoQ
         4LwzzshQKa7TEtrKhw2uM6JroijJdomemkOdg=
From: Eric Lacombe <goretux@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [x86] fs, gs purpose & multicore prog
Date: Sat, 6 Sep 2008 01:09:52 +0200
User-Agent: KMail/1.10.0 (Linux/2.6.26.3; KDE/4.1.64; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200809031109.45660.goretux@gmail.com> <200809051317.11116.goretux@gmail.com> <48C1477B.6060500@goop.org>
In-Reply-To: <48C1477B.6060500@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809060109.52419.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks again ;)

On Vendredi 05 Septembre 2008 16:51:39 Jeremy Fitzhardinge wrote:
> Eric Lacombe wrote:
[...]
> >>> - What is the purpose of MSR_FS_BASE and MSR_GS_BASE ?
> >>> (I thought they were filled with "gdt[fs_entry].base")
> >>
> >> On 64-bit, the GDT isn't large enough to hold a 64-bit offset, so it
> >> only stores the low 32-bits.  When you load a segment register with a
> >> selector, it picks up from the gdt.  If you want a full 64-bit offset,
> >> you need to write it to the msr.
> >
> > Ok, I just saw that a 64-bit base in segment descriptor is only available
> > for the system descriptor.
>
> Yes, the IDT has double-wide entries to fit 64-bit values, but they
> didn't extend that to the GDT.  Or something - I last looked at this a
> couple of months ago, and it never sticks in my brain for long.

It seems, there also are the TSS and LDT.

>
> > Ok, but how does the kernel technically run tasks on different processor
> > (or core)? My question was ambiguous, I was not assuming that I knew how
> > multiprocessor works.
>
> That's a very broad question.  A good proportion of the core kernel code
> is dedicated to doing just that.  Very roughly, at boot time it brings
> up all the cpus, and they more or less run independently each looking
> for work to do in the form of processes waiting to run on the run
> queue.  They collectively run the scheduler algorithms to work out who
> runs what when; almost everything run in the kernel is a task - both
> usermode processes and kernel threads.  Except for the stuff which isn't.

I know these things ;) but what I wanted to know is the "x86 architectural 
details". In fact, I saw that during the machine init the BIOS select a cpu on 
the bus to be the BSP (bootstrap proc). The others are then the APs (Appli 
proc). Then the kernel runs on the BSP. What I wonder is how the kernel gives 
execution flow to the APs.

Thanks.

	Eric

>
>     J

