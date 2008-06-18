Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbYFRIDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbYFRIDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 04:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYFRIDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 04:03:09 -0400
Received: from www.tglx.de ([62.245.132.106]:34676 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYFRIDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 04:03:06 -0400
Date: Wed, 18 Jun 2008 10:02:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806180025.20504.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0806181000440.3395@apollo.tec.linutronix.de>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806172244.24026.rjw@sisk.pl> <200806180019.49628.rjw@sisk.pl> <200806180025.20504.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, Rafael J. Wysocki wrote:
> On Wednesday, 18 of June 2008, Rafael J. Wysocki wrote:
> > On Tuesday, 17 of June 2008, Rafael J. Wysocki wrote:
> > > On Tuesday, 17 of June 2008, Thomas Gleixner wrote:
> > > > On Tue, 17 Jun 2008, Rafael J. Wysocki wrote:
> > > > > 
> > > > > BTW, with the C1E patches reverted I don't get the
> > > > > WARNING: at /home/rafael/src/linux-next/kernel/smp.c:215 smp_call_function_single+0x3d/0xa2
> > > > > in the log.  Thomas?
> > > > 
> > > > Yeah, my bad. Fix below.
> > > 
> > > Thanks, it eliminates the WARNING, but still the box doesn't work with
> > > the "x86: add C1E aware idle function" patch applied, even with 'highres=off'.
> > > 
> > > The main symptom is that CPU loads are computed incorrectly (I got X using 126%
> > > of CPU time from 'top', for example).  Apart from this, some processes (like
> > > gkrellm) seem to be 'frozen' and only change their state in 'jumps', as though
> > > they only got CPU from time to time at random.
> > > 
> > > Reverting the above-mentioned patch fixes those problems.
> > 
> > Ah.  If your fix is replaced with the appended one, the system happily works
> > with C1E and highres.
> 
> Scratch that.  The symptoms appeared later this time, that's all.  I've just got
> b43 consuming 90+ % of the CPU time. :-(

I would have been pretty surprised if it had helped :)

Does the box boot when you disable the local apic timer on the kernel
command line with the patch applied ?

Also does forcing hpet change anything ?

Thanks,
	tglx


