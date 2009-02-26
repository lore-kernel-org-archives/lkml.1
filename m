Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbZBZV72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbZBZV72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZBZV7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:59:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38560 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZBZV7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:59:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Thu, 26 Feb 2009 22:58:54 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902261050.50531.rjw@sisk.pl> <d6200be20902261234i5a3896fo78a7f56d16a247c7@mail.gmail.com>
In-Reply-To: <d6200be20902261234i5a3896fo78a7f56d16a247c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902262258.55835.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Arve Hjønnevåg wrote:
> On Thu, Feb 26, 2009 at 1:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday 26 February 2009, Arve Hjønnevåg wrote:
> >> On Tue, Feb 24, 2009 at 3:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > BTW, appended is the current (3rd) version of the $subject patch with some
> >> > of your comments taken into account.  In particular, I did the following:
> >> > - moved [suspend|resume]_device_irqs() to a separate file (pm.c)
> >> > - fixed interrupt.h so that their headers are at a better place
> >> > - made enable_irq() clear IRQ_SUSPENDED
> >> > - made device_power_down() and device_power_up() call
> >> >  suspend_device_irqs() and resume_device_irqs(), respectively, which
> >> >  simplified the callers quite a bit (it changed the Xen code ordering, though,
> >> >  but I _think_ it still should work).
> >>
> >> Do you plan to fix edge triggered wakeup interrupts? It still looks
> >> like edge triggered wakeup interrupts that occur between
> >> suspend_device_irqs and local_irq_disable will not cause a wakeup.
> >
> > In the current version of the patch the interrupts that have IRQ_WAKEUP set
> > in status are not disabled.  Is this not enough?
> 
> That is enough for drivers that use wakelocks to abort suspend (if I
> fix the wakelock code to not use a platform device as its last abort
> point). It is not enough if you don't have wakelocks, since the
> interrupt can occur after suspend_late has been called and the driver
> has no way to abort suspend.

Well, how exactly the $subject patch does cause this problem to happen?

Rafael
