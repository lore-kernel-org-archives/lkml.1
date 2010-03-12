Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab0CLRV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:21:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48574 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933238Ab0CLRV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:21:59 -0500
Date: Fri, 12 Mar 2010 17:21:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ameya Palande <ameya.palande@nokia.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] regulator: Get rid of lockdep warning
Message-ID: <20100312172156.GB22822@rakim.wolfsonmicro.main>
References: <37adb5f9cc7986b51b7b560cf7644ac5177a6e34.1268411141.git.ameya.palande@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37adb5f9cc7986b51b7b560cf7644ac5177a6e34.1268411141.git.ameya.palande@nokia.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 07:16:36PM +0200, Ameya Palande wrote:

> @@ -1045,6 +1045,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
>  		regulator->dev_attr.attr.owner = THIS_MODULE;
>  		regulator->dev_attr.attr.mode = 0444;
>  		regulator->dev_attr.show = device_requested_uA_show;
> +		sysfs_attr_init(&regulator->dev_attr.attr);
>  		err = device_create_file(dev, &regulator->dev_attr);
>  		if (err < 0) {
>  			printk(KERN_WARNING "%s: could not add regulator_dev"

Without having looked at what sysfs_attr_init() is actually doing it
looks odd to be calling an init() function after having initialised
several members of the structure - I'd expect to see the call happen
before we start writing stuff in?
