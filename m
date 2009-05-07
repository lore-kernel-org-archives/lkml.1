Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZEGJi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZEGJi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZEGJiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:38:46 -0400
Received: from rrzmta1.rz.uni-regensburg.de ([194.94.155.51]:25854 "EHLO
	rrzmta1.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755991AbZEGJip convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:38:45 -0400
X-Greylist: delayed 1411 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 May 2009 05:38:45 EDT
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaetsklinikum Regensburg
To: "George Spelvin" <linux@horizon.com>
Date: Thu, 07 May 2009 11:14:45 +0200
MIME-Version: 1.0
Subject: Re: [RFC][PATCH] Adjust SHIFT_PLL to improve NTP convergence.
CC: linux-kernel@vger.kernel.org, linux@horizon.com, tglx@linutronix.de,
       ulrich.windl@rz.uni-regensburg.de, williams@redhat.com,
       zippel@linux-m68k.org
Message-ID: <4A02C2A7.4033.ED06D54@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-reply-to: <20090506144645.30215.qmail@science.horizon.com>
References: <1241471016.7444.80.camel@localhost.localdomain>, <20090506144645.30215.qmail@science.horizon.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 8BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.29/Sophos-P=4.41.0+V=4.41+U=2.07.230+R=04 May 2009+T=728146@20090507.090400Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2009 at 10:46, George Spelvin wrote:

[...]
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

Hi,

IMHO, the "value" of calibration during boot is dubious (unless you just reboot a 
"hot" machine): Usually the machine is cold on reboot, and the oscillators will 
drift a lot initially. Depending on your environment, the temperatures inside your 
box may rise about 10°C or more within a few minutes.

Maybe an experimental feature "recalibrate anytime (and as long as you'd like)" 
would be interesting...

Regards,
Ulrich

