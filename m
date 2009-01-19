Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbZASNAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbZASNAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbZASNAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:00:06 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49110 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759918AbZASNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:00:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=cOvV9y+hRedI13eQcaVvOUZ0QxREda1teBBJd0JE1jt1LQ1iSIqtANMf0nTDWkK2Da
         HEn+WcWcrX0RBdxkDtNN6hva1VS9Ivp5276vLqVHGovo0u4EkG4EZe60D/sHia1uVZ2s
         3+yw4pGa/kxxV4ukh7Qm6un2+Lkw9xBj/eqGE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II processor
Date: Mon, 19 Jan 2009 13:41:53 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-next-20090116; KDE/4.1.3; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Mark Hounschell <markh@compro.net>
References: <497322CC.7050900@cfl.rr.com> <49743E52.7010906@cfl.rr.com>
In-Reply-To: <49743E52.7010906@cfl.rr.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901191341.54081.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Mark Hounschell wrote:
> Mark Hounschell wrote:
> > I upgraded from a Phenom to a Phenom-II processor and I could no longer boot.
> > 
> > I have tried kernels from 2.6.26 through 2.6.28.
> > 
> > I _can_ however boot these kernels when they are configured for HZ = 250. I
> > haven't tried HZ = 300. But certainly if HZ = 1000 the boot hangs at the spot
> > indicated below in the dmesg output.
> > 
> > The machine is up and stable running 2.6.26.8 with a (HZ = 1000) configured kernel.
> > 
> 
> The machine is up and stable running 2.6.26.8 with a (HZ = 250) configured
> kernel. Sorry.
> 
> > While running a 2.6.26.8 kernel configured for HZ = 250:

[...]

> > Checking if this processor honours the WP bit even in supervisor mode...Ok.
> > 
> > 
> >       The 2.6.26.8 kernel hangs up right here.
> > 
> > 
> > CPA: page pool initialized 1 of 1 pages preallocated
> > SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> > hpet clockevent registered
> > calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
> > Probably due to long platform interrupts. Consider using "lpj=" boot option.
> > Calibrating delay loop... 3956.73 BogoMIPS (lpj=7913472)

Even if it boots it may not work reliably since lpj/BogoMIPS are too small
(they should be the same as for other CPUs) which in turn could result in too
short delay loops.

> > Security Framework initialized
> > Capability LSM initialized
> > Mount-cache hash table entries: 512
> > CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> > CPU: L2 Cache: 512K (64 bytes/line)
> > CPU 0(4) -> Core 0
> > Checking 'hlt' instruction... OK.
> > ACPI: Core revision 20080321
> > ENABLING IO-APIC IRQs
> > ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> > CPU0: AMD Processor model unknown stepping 02
> > Booting processor 1/1 ip 2000
> > Initializing CPU#1
> > Calibrating delay using timer specific routine.. 6000.60 BogoMIPS (lpj=12001200)

Here are the proper values.

> > CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> > CPU: L2 Cache: 512K (64 bytes/line)
> > CPU 1(4) -> Core 2
> > x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> > CPU1: AMD Processor model unknown stepping 02
> > Booting processor 2/2 ip 2000
> > Initializing CPU#2
> > Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000950)

also OK

> > CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> > CPU: L2 Cache: 512K (64 bytes/line)
> > CPU 2(4) -> Core 1
> > x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
> > CPU2: AMD Processor model unknown stepping 02
> > Booting processor 3/3 ip 2000
> > Initializing CPU#3
> > Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000955)

ditto

That being said I don't know why delay calibration loop fails on CPU0.

You may try booting with "lpj=12001200" kernel parameter to workaround
the issue (it should fix booting with HZ == 1000) and/or try 2.6.29-rc2
(the problem may have been already fixed).

Thanks,
Bart
