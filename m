Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZELIhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZELIhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbZELIhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:37:07 -0400
Received: from rrzmta5.rz.uni-regensburg.de ([194.94.155.56]:36043 "EHLO
	rrzmta5.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276AbZELIhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:37:05 -0400
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaetsklinikum Regensburg
To: john stultz <johnstul@us.ibm.com>
Date: Tue, 12 May 2009 10:36:37 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
CC: ulrich.windl@rz.uni-regensburg.de, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Clark Williams <williams@redhat.com>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>
Message-ID: <4A095139.30347.48783F@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-reply-to: <1242094321.7214.156.camel@localhost.localdomain>
References: <1242094321.7214.156.camel@localhost.localdomain>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.29/Sophos-P=4.41.0+V=4.41+U=2.07.230+R=04 May 2009+T=728309@20090512.083650Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 May 2009 at 19:12, john stultz wrote:

> All, 
> 
> Despite recent tweaking, TSC calibration variance is still biting users
> who care about keeping close sync with NTP servers over reboots.
> 
> Here's a recent example:
> http://lkml.indiana.edu/hypermail/linux/kernel/0905.0/02061.html
> 
> The problem is, each reboot, we have to calibrate the TSC, and any
> error, regardless of how small, in the calibrated freq has to be
> corrected for by NTP. Assuming the error is within 500ppm NTP can
> correct this, but until it finds the proper correction value for the new
> TSC freq, users may see time offsets from the NTP server.
> 
> In my experience, its fairly easy to see 100khz variance from reboot to
> reboot with 2.6.30-rc.
> 
> While I think its worth trying to improve the calibration further, there
> will likely be a trade-off between very accurate calibration and fast
> boot times.
> 
> To mitigate this, I wanted to provide a tsc_khz= boot option. This would
> allow users to set the tsc_khz value at boot-up, assuming they are
> within 1Mhz of the calibrated value (to protect against bad values).
> Once the tsc_khz value is set in grub, the box will always boot with the
> same value, so the NTP drift value prior to reboot will still be correct
> after rebooting.

[...]

Hi everyone!

I was thinking a little bit on the issue, and I wondered (assuming the TSC 
calibration and the hardware is somewhat stable) whether one should invent a 
mechanism similar to the RTC or random pool; i.e. load the last value that was 
stored or accumulated before. For the TSC calibaration one could build the average 
of previous calibration values (if the value jumps between different numbers).
That would require a sysctl (or equivalent) interface however.

Regards,
Ulrich

