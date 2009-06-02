Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbZFBEu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbZFBEu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbZFBEuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:50:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:33272 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbZFBEuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:50:51 -0400
Subject: Re: [regression, bisected] adb trackpad disappears after suspend
 to ram
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200906011836.15507.rjw@sisk.pl>
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	 <200905292010.10615.rjw@sisk.pl>
	 <87fxekxe3w.fsf@scholz.fias.uni-frankfurt.de>
	 <200906011836.15507.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 14:49:24 +1000
Message-Id: <1243918164.5308.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So, it seems we lose and interrupt during resume and that confuses the
> ADB controller driver or something like this.  Do you use the keyboard or
> the trackpad as a wake-up device?
> 
> Please additionally try to go back to the original code, put
> 'sleepy_trackpad = 1' at the beginning of do_adb_reset_bus() in
> drivers/macintosh/adb.c and see if the problem is reproducible with that.

Well, the ADB controller is also the PMU (drivers/macintosh/via-pmu.c)
which is also the system controller, handles the actual sleep state,
etc... :-)

That code is a bit itchy around the edges. I'm not sure it would have
lost an interrupt, that sounds more like losing an IRQ would have broken
it completely but it's not -impossible- (especially if it's the external
GPIO or CB1 interrupt that notifies of an incoming ADB message).

I haven't managed to reproduce the problem yet here though. I'll see if
I can with a titanium powerbook I have somewhere in storage that might
be a bit closer to your machine than the wallstreet powerbook I've been
using to test at work :-) My other powerbook test machine uses a USB
trackpad. 

Cheers,
Ben.


