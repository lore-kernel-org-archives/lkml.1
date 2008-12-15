Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYLOOFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYLOOFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYLOOFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:05:09 -0500
Received: from mail.openmoko.org ([88.198.124.205]:33876 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbYLOOFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:05:08 -0500
Date: Mon, 15 Dec 2008 19:34:50 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Mark Brown <broonie@sirena.org.uk>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
       Liam Girdwood <lrg@simlogic.co.uk>
Subject: Re: [PATCH 7/7] regulator: PCF50633 pmic driver
Message-ID: <20081215140448.GA2625@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail> <20081214110400.3307.57681.stgit@cff.thadambail> <20081215113547.GC31145@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215113547.GC31145@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 11:35:49AM +0000, Mark Brown wrote:
> On Sun, Dec 14, 2008 at 04:34:00PM +0530, Balaji Rao wrote:
> 
> > +struct regulator_ops pcf50633_regulator_ops = {
> > +	.set_voltage = pcf50633_regulator_set_voltage,
> > +	.get_voltage = pcf50633_regulator_get_voltage,
> > +	.enable = pcf50633_regulator_enable,
> > +	.disable = pcf50633_regulator_disable,
> > +	.is_enabled = pcf50633_regulator_is_enabled,
> > +	.set_suspend_enable = pcf50633_regulator_enable,
> > +	.set_suspend_disable = pcf50633_regulator_disable,
> > +};
> 
> Are you sure that the suspend variants of the operations should be the
> same as the regular versions?
> 

Yes, basically the chip doesn't change state during suspend/resume.
We just enable or disable them the usual way.

> > +struct platform_driver pcf50633_regulator_driver = {
> > +	.driver = {
> > +		.name = "pcf50633-regltr",
> > +	},
> > +	.probe = pcf50633_regulator_probe,
> > +	.remove = __devexit_p(pcf50633_regulator_remove),
> > +};
> 
> Not that it matters too much but I have a hard time liking "regltr".

Ha! The name pcf50633-regulator exceeds 20 chars and there is no space
remaining for the ".0" or ".1" at the end. This gave me a sysfs warning
and so I changed it.

	- Balaji
