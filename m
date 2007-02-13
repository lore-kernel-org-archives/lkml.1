Return-Path: <linux-kernel-owner+w=401wt.eu-S1751375AbXBMWip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbXBMWip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXBMWip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:38:45 -0500
Received: from ns.suse.de ([195.135.220.2]:50921 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbXBMWip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:38:45 -0500
Date: Tue, 13 Feb 2007 23:38:33 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
       linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Message-ID: <20070213223833.GB7615@v2.random>
References: <20070201095952.589234000@jet.suse.cz> <1171348808.12771.19.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0702130906530.23634@schroedinger.engr.sgi.com> <200702131820.15180.ak@suse.de> <20070213221848.GF9189@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213221848.GF9189@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 13, 2007 at 11:18:48PM +0100, Vojtech Pavlik wrote:
> It's not inherent to ntpd's design, but the current (which may have been
> fixed since I looked last) implementation of the NTP PLL in the kernel.
> 
> The interaction with ntpd can be fixed and I've done it in the past
> once, although the fix wasn't all that nice.

Yep, it can slowly move towards the correct time, but ntpdate (or more
generally settimeofday) remains a fundamental issue (and I prefer time
skews to be fixed ASAP, not slowly).

If the admin is good, he can know that if he ever runs the db when the
clock isn't perfectly synchronized with the atomic clock, he risks to
screwup his whole dataset as the apps won't even handle time going
backwards after reboot.

I think there should be a limit to how much an app can pretend from
gtod before generating failures. Certainly it's always better to write
apps that are robust against a not monotonic gtod because eventually
it _can_ happen (either that or remove the stod syscall ;).

About ntpdate at boot and ntpd at runtime, not running them isn't
really an option on the server IMHO, think the liability if system
time runs out of sync of a minute and you need to know exactly when
something bad has happened.
