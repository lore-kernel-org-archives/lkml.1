Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZBVXC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZBVXC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZBVXCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:02:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:35729 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZBVXCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:02:18 -0500
Subject: Re: [RFC][PATCH 0/2] Rework disabling of interrupts during
 suspend-resume
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <m1skm6cd3z.fsf@fess.ebiederm.org>
References: <200902221837.49396.rjw@sisk.pl>
	 <m1skm6cd3z.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 09:56:25 +1100
Message-Id: <1235343385.8805.218.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-22 at 14:37 -0800, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Moreover, the real purpose of these changes is to be able to execute the
> > "late" suspend and "early" resume device callbacks with timer interrupts
> > enabled, so that they can use mutexes etc.  However, x86 currently doesn't set
> > the IRQF_TIMER flag and I need to make it do so before going further in this
> > direction and changing the PCI PM framework to take advantage of the $subject
> > changes, for example.  So, I need to know how to modify x86 timer code so that
> > the IRQF_TIMER flag is set by it.
> 
> How does this sync with the ACPI requirement that the it's late suspend MUST
> happen with irqs disabled?

If I understand properly what the intention here is, the sysdev suspend
and later still happens with hard irqs off.

This is purely the layer between suspend and suspend_late at the driver
level that uses the above instead of hard IRQs off in order to be able
to properly order the ACPI calls vs. the driver calls.

Ben.


