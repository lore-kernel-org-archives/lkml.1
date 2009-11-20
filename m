Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZKTKos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZKTKos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZKTKos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:44:48 -0500
Received: from poutre.nerim.net ([62.4.16.124]:52674 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZKTKor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:44:47 -0500
Date: Fri, 20 Nov 2009 11:44:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] k10temp: temperature sensor for AMD Family
  10h/11h CPUs
Message-ID: <20091120114450.12c0be85@hyperion.delvare>
In-Reply-To: <87ws1l5wcl.fsf@depni.sinp.msu.ru>
References: <4AF91F70.10106@ladisch.de>
	<4B06501B.8080509@ladisch.de>
	<87ws1l5wcl.fsf@depni.sinp.msu.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 10:22:50 +0000, Serge Belyshev wrote:
> 
> > +All these processors have a sensor, but on older revisions of Family 10h
> > +processors, the sensor returns inconsistent values (erratum 319). The driver
> > +refuses to load with these revisions (DR-BA, DR-B2, DR-B3: some Embedded
> > +Opterons on Socket F; and Quad-Core Opteron, Phenom Triple/Quad-Core, and
> > +Athon Dual-Core on Socket AM2+). All later revisions (RB-C2, BL-C2, DA-C2,
> > +RB-C3, HY-D0) work fine; see the list above.
> 
> Please note that erratum actually states that the sensor only "may report
> inconsistent values.", not that it is always broken.  As evident by my
> own experience (tested with a userspace application), it actually works
> perfectly on all B3 stepping processors that I have.

We don't care that 5% of the CPU have working sensors. 95% [1] of
theses CPUs have broken sensors and their users will ask us for help
and we are fed up with this. So all these CPUs are blacklisted, period.

> > +static bool __devinit has_erratum_319(void)
> > +{
> > +	/*
> > +	 * Erratum 319: The thermal sensor of older Family 10h processors
> > +	 *              (B steppings) is unreliable.
> > +	 */
> > +	return boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model <= 2;
> > +}
> ...
> > +	if (has_erratum_319()) {
> > +		dev_err(&pdev->dev,
> > +			"unreliable CPU thermal sensor; monitoring disabled\n");
> > +		err = -ENODEV;
> > +		goto exit;
> > +	}
> 
> So, please provide an alternative for those who have a working sensor on a
> revision B processor and want to use it.

The alternative already exists: you can rebuild the driver yourself
without this check.

Or yet another alternative: become the maintainer of the hwmon
subsystem, and do lm-sensors user support for a couple years. Then you
will be allowed to decide what goes in.

And yet another one: instead of asking others to solve your very own
problem, why don't you try and solve it yourself? I'm sure Clemens
would welcome patches to his driver.

Thank you very much.

[1] Yes these numbers are totally made up. There is no reliable way to
tell a broken sensor from a working one anyway.

-- 
Jean Delvare
