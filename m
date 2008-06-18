Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYFRTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYFRTWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYFRTWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:22:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4189 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751855AbYFRTWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:22:12 -0400
Date: Wed, 18 Jun 2008 21:21:48 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [patch 6/6] x86: add c1e aware idle function
Message-ID: <20080618192148.GA4243@ucw.cz>
References: <20080610171639.551369443@linutronix.de> <20080610171712.465591661@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610171712.465591661@linutronix.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-06-12 10:29:00, Thomas Gleixner wrote:
> C1E on AMD machines is like C3 but without control from the OS. Up to
> now we disabled the local apic timer for those machines as it stops
> when the CPU goes into C1E. This excludes those machines from high
> resolution timers / dynamic ticks, which hurts especially the X2 based
> laptops.
> 
> The current boot time C1E detection has another more serious flaw:
> some BIOSes do not enable C1E until the ACPI processor module is
> loaded. This causes systems to stop working after that point.
> 
> To work nicely with C1E enabled machines we use a separate idle
> function, which checks on idle entry whether C1E was enabled in the
> Interrupt Pending Message MSR. This allows us to do timer broadcasting

Entering idle is quite a common operation, and reading MSR is quite
slow. Is it possible to do better here?

What happens if ACPI BIOS toggles MSR on all cpus *while* we are
entering idle? This seems inherently racy...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
