Return-Path: <linux-kernel-owner+w=401wt.eu-S942150AbXHJVId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942150AbXHJVId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbXHJVIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:08:24 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:59588 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755535AbXHJVIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:08:23 -0400
Date: Fri, 10 Aug 2007 23:08:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
Message-ID: <20070810230831.59cbc50f@hyperion.delvare>
In-Reply-To: <46B6053E.2050708@s5r6.in-berlin.de>
References: <46B5B290.4040907@s5r6.in-berlin.de>
	<20070805162141.GI6221@jupiter.solarsys.private>
	<46B6053E.2050708@s5r6.in-berlin.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Sun, 05 Aug 2007 19:13:34 +0200, Stefan Richter wrote:
> Mark M. Hoffman wrote:
> > Does this patch (against v2.6.23-rc2) fix it?
> > 
> > commit f15c50e703c14ff7d72c3cb34e8e55417476a290
> > Author: Mark M. Hoffman <mhoffman@lightlink.com>
> > Date:   Sun Aug 5 12:19:01 2007 -0400
> > 
> >     hwmon: read fan_div values during probe
> >     
> >     This patch forces the driver to read the fan divider values during early init.
> >     Otherwise, a call to store_fan_min() could access uninitialized variables.
> 
> Alas not; there is no change.
> (I applied on vanilla 2.6.23-rc2 and rebooted.)

I just tried 2.6.23-rc2 on a system where I use the w83627ehf hardware
monitoring driver, and was not able to reproduce the problem you
described. Fan speeds are reported properly for me. Which I kind of
expected, as I tested all my w83627ehf patches on this system before
submitting them.

Please try using sensors instead of ksensors, and confirm that the
behavior is the same. I'd like to rule out a problem in ksensors
itself. sensors will also report the fan divs, this is a useful
information given the problem you have.

Your original post suggests that the fan speed is supposed to change
depending on the system load? Or temperature? Please describe the
mechanism used to achieve this. Could it be that this mechanism isn't
working properly, and the reported (low) speeds are actually true?

What fan inputs are used by your CPU and system fans? "sensors
-c /dev/null" will tell.

Other than that, I can only ask for the same things Mark already
suggested: compile with HWMON debugging and provide the logs (this will
show what fan div the driver is trying to select), and try bisecting
using git to find out which patch exactly caused the problem.

Thanks,
-- 
Jean Delvare
