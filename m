Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbZIFBei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbZIFBei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 21:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZIFBeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 21:34:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33867 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZIFBeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 21:34:36 -0400
Date: Sun, 6 Sep 2009 02:34:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       linux-kernel@vger.kernel.org
Message-ID: <20090906013431.GB4239@sirena.org.uk>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com>
 <1252081568-6000-2-git-send-email-mjg@redhat.com>
 <20090904182528.591dbd29@i1501.lan.towertech.it>
 <20090904163029.GA25239@srcf.ucam.org>
 <20090904183828.4376236e@i1501.lan.towertech.it>
 <20090904164127.GB25419@srcf.ucam.org>
 <20090904185243.53c9b440@i1501.lan.towertech.it>
 <20090904165549.GA25802@srcf.ucam.org>
 <20090904190345.02733404@i1501.lan.towertech.it>
 <20090904170928.GA26009@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904170928.GA26009@srcf.ucam.org>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [rtc-linux] Re: [PATCH 2/2] rtc: Add boot_timesource sysfs
 attribute
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 06:09:28PM +0100, Matthew Garrett wrote:

> +hctosys:   	 1 if the RTC provided the system time at boot via the
> +		 CONFIG_RTC_HCTOSYS kernel option, 0 otherwise

...

> +static ssize_t
> +rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *attr,
> +		char *buf)
> +{
> +#ifdef CONFIG_RTC_HCTOSYS_DEVICE
> +	if (strcmp(dev_name(&to_rtc_device(dev)->dev),
> +		   CONFIG_RTC_HCTOSYS_DEVICE) == 0)
> +		return sprintf(buf, "1\n");
> +	else
> +#endif

Strictly speaking this only reports if the RTC was configured to provide
the system time at boot, it does not check to see if it actually
succeeded in doing so.  Obviously failures here are a relatively rare
occurrance but they can happen.  I don't think it's worth changing the
code since it's unlikely userspace will be able to do any better than
the kernel did but it might be worth updating the documentation just in
case.
