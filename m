Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbZEFPo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbZEFPo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZEFPoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:44:20 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58266 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbZEFPoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:44:19 -0400
Subject: Re: [RFC][PATCH] Adjust SHIFT_PLL to improve NTP convergence.
From: John Stultz <johnstul@us.ibm.com>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       ulrich.windl@rz.uni-regensburg.de, williams@redhat.com,
       zippel@linux-m68k.org
In-Reply-To: <20090506144645.30215.qmail@science.horizon.com>
References: <20090506144645.30215.qmail@science.horizon.com>
Content-Type: text/plain
Date: Wed, 06 May 2009 08:44:00 -0700
Message-Id: <1241624640.9110.3.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 10:46 -0400, George Spelvin wrote:
> > As always, feedback or testing (especially on non-x86 arches) would be
> > greatly appreciated.
> 
> Applying it to a couple of PPS-synchronized machines (where I had already
> dropped the poll interval into the basement for better convergence, have
> to try reverting that) seems to be working.


Thanks for the testing!

> One thing I just noticed, although I'm sure it has happened in the past,
> is that there's a frequency jump each boot due to TSC recalibration.
> 
> 		Machine 1	Machine 2
> Old CPU MHz	2500.170	2500.138
> Old NTP ppm	-24.63 +/-0.01	-30.27 +/-0.02
> 
> New CPU MHz	2500.176	2500.193
> New NTP ppm	-22.26 +/-0.01	-8.20 +/-0.015 
> 
> "True" CPU MHz	2500.2316	2500.2136
> 
> I should look and see if there's an easy way to tighten that tolerance.
> The current algorithm is fine for jiffies purposes, but a few seconds'
> worth of background calibration would produce a more stable estimate.

Yea. The TSC calibration issue has been around for awhile. Although the
code has been tweaked recently, I'm not seeing that much improved
consistency from reboot to reboot.

Its a hard trade off for folks who need very quick boot time, vs folks
that want very stable and accurate clocks across reboots.

I'll be looking into the calibration code to see how much is needed to
bring the error rate down.

thanks
-john


