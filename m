Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZKTKwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZKTKwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZKTKwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:52:54 -0500
Received: from depni.sinp.msu.ru ([213.131.7.21]:47594 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZKTKwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:52:54 -0500
X-Greylist: delayed 1807 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 05:52:54 EST
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] k10temp: temperature sensor for AMD Family 10h/11h CPUs
References: <4AF91F70.10106@ladisch.de> <4B06501B.8080509@ladisch.de>
Date: Fri, 20 Nov 2009 10:22:50 +0000
In-Reply-To: <4B06501B.8080509@ladisch.de> (Clemens Ladisch's message of "Fri,
	20 Nov 2009 09:15:23 +0100")
Message-ID: <87ws1l5wcl.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +All these processors have a sensor, but on older revisions of Family 10h
> +processors, the sensor returns inconsistent values (erratum 319). The driver
> +refuses to load with these revisions (DR-BA, DR-B2, DR-B3: some Embedded
> +Opterons on Socket F; and Quad-Core Opteron, Phenom Triple/Quad-Core, and
> +Athon Dual-Core on Socket AM2+). All later revisions (RB-C2, BL-C2, DA-C2,
> +RB-C3, HY-D0) work fine; see the list above.

Please note that erratum actually states that the sensor only "may report
inconsistent values.", not that it is always broken.  As evident by my
own experience (tested with a userspace application), it actually works
perfectly on all B3 stepping processors that I have.

> +static bool __devinit has_erratum_319(void)
> +{
> +	/*
> +	 * Erratum 319: The thermal sensor of older Family 10h processors
> +	 *              (B steppings) is unreliable.
> +	 */
> +	return boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model <= 2;
> +}
...
> +	if (has_erratum_319()) {
> +		dev_err(&pdev->dev,
> +			"unreliable CPU thermal sensor; monitoring disabled\n");
> +		err = -ENODEV;
> +		goto exit;
> +	}

So, please provide an alternative for those who have a working sensor on a
revision B processor and want to use it.
