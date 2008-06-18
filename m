Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYFROjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYFROjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYFROjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:39:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44100 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbYFROjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:39:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Wed, 18 Jun 2008 16:40:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <alpine.LFD.1.10.0806181000440.3395@apollo.tec.linutronix.de> <alpine.LFD.1.10.0806181421320.3395@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0806181421320.3395@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181640.45595.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 18 of June 2008, Thomas Gleixner wrote:
> On Wed, 18 Jun 2008, Thomas Gleixner wrote:
> > On Wed, 18 Jun 2008, Rafael J. Wysocki wrote:
> > > On Wednesday, 18 of June 2008, Rafael J. Wysocki wrote:
> > > > On Tuesday, 17 of June 2008, Rafael J. Wysocki wrote:
> > > > > On Tuesday, 17 of June 2008, Thomas Gleixner wrote:
> > > > > > On Tue, 17 Jun 2008, Rafael J. Wysocki wrote:
> > > > > > > 
> > > > > > > BTW, with the C1E patches reverted I don't get the
> > > > > > > WARNING: at /home/rafael/src/linux-next/kernel/smp.c:215 smp_call_function_single+0x3d/0xa2
> > > > > > > in the log.  Thomas?
> > > > > > 
> > > > > > Yeah, my bad. Fix below.
> > > > > 
> > > > > Thanks, it eliminates the WARNING, but still the box doesn't work with
> > > > > the "x86: add C1E aware idle function" patch applied, even with 'highres=off'.
> > > > > 
> > > > > The main symptom is that CPU loads are computed incorrectly (I got X using 126%
> > > > > of CPU time from 'top', for example).  Apart from this, some processes (like
> > > > > gkrellm) seem to be 'frozen' and only change their state in 'jumps', as though
> > > > > they only got CPU from time to time at random.
> > > > > 
> > > > > Reverting the above-mentioned patch fixes those problems.
> > > > 
> > > > Ah.  If your fix is replaced with the appended one, the system happily works
> > > > with C1E and highres.
> > > 
> > > Scratch that.  The symptoms appeared later this time, that's all.  I've just got
> > > b43 consuming 90+ % of the CPU time. :-(
> > 
> > I would have been pretty surprised if it had helped :)
> > 
> > Does the box boot when you disable the local apic timer on the kernel
> > command line with the patch applied ?
> > 
> > Also does forcing hpet change anything ?
> 
> I just checked that the original c1e series and the affected code in
> tip are not different. IIRC you confirmed that the C1E patches would
> work on your box. So I wonder what else got changed which causes these
> problems.

Well, to eliminate any possible correlations, do you have a version of the
series or a single patch against the current mainline?

Rafael
