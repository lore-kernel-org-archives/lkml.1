Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZBWWYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZBWWYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZBWWYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:24:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZBWWYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:24:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Mon, 23 Feb 2009 23:23:24 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902221839.50357.rjw@sisk.pl> <d6200be20902231411s654f8b3csf1388a97f3f94ac4@mail.gmail.com>
In-Reply-To: <d6200be20902231411s654f8b3csf1388a97f3f94ac4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902232323.25583.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Arve Hjønnevåg wrote:
> On Sun, Feb 22, 2009 at 9:39 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Introduce two helper functions allowing us to disable device
> > interrupts (at the IO-APIC level) during suspend or hibernation
> > and enable them during the subsequent resume, respectively, so that
> > the timer interrupts are enabled while "late" suspend callbacks and
> > "early" resume callbacks provided by device drivers are being
> > executed.
> >
> > Use these functions to rework the handling of interrupts during
> > suspend (hibernation) and resume.  Namely, interrupts will only be
> > disabled on the CPU right before suspending sysdevs, while device
> > interrupts will be disabled (at the IO-APIC level), with the help of
> > the new helper function, before calling "late" suspend callbacks
> > provided by device drivers and analogously during resume.
> >
> 
> What impact does this have on wakeup interrupts? Unless you add a
> check, after masking all interrupt at the CPU, to abort suspend if any
> wakeup interrupt has IRQ_PENDING set I think you will loose wakeup
> interrupts (at least for irqs that use default_disable).

I _think_ they would have to be reenabled after we've called
local_irq_disable().

Thanks,
Rafael
