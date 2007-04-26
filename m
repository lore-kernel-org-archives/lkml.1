Return-Path: <linux-kernel-owner+w=401wt.eu-S1031196AbXDZPyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031196AbXDZPyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031283AbXDZPyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:54:09 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:3486 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031196AbXDZPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:54:07 -0400
Date: Thu, 26 Apr 2007 17:54:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH][RFC] i2c: adds support for i2c bus on 8xx
Message-ID: <20070426175438.391157a1@hyperion.delvare>
In-Reply-To: <462F8A82.40604@kernel.crashing.org>
References: <20070420082714.4f10f186@localhost.localdomain>
	<20070421095707.6b42a312@hyperion.delvare>
	<20070422152937.7332fc31@localhost.localdomain>
	<20070423111950.129856eb@hyperion.delvare>
	<462F8A82.40604@kernel.crashing.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

On Wed, 25 Apr 2007 21:06:10 +0400, Vitaly Bordug wrote:
> Jean Delvare wrote:
> >>>> +/* Structure for a device driver */
> >>>> +static struct device_driver i2c_rpx_driver = {
> >>>> +	.name = "fsl-i2c-cpm",
> >>>> +	.bus = &platform_bus_type,
> >>>> +	.probe = i2c_rpx_probe,
> >>>> +	.remove = i2c_rpx_remove,
> >>>> +};
> >>>>         
> >>> Why don't you declare it as a struct platform_driver, register it with
> >>> platform_driver_register() and unregister it with
> >>> platform_driver_unregister()?
> >>>       
> >> Well. This stuff belongs to CPM1, of the mpc8xx family, but the
> >> target boards are different, and they may/should provide board
> >> specific inits and filling of platform data. With
> >> platform_driver_register we may end up with ifdef stuff here
> >> (which is evil).
> >>     
> >
> > I don't follow you here, sorry. Platform devices are declared by
> > board-specific code which can include all the needed initialization.
> > And device-specific data can be carried to the platform driver for
> > further use. The platform device/driver infrastructure is meant to
> > handle that kind of situation, so there really is no excuse that I can
> > see not to use it. i2c-omap and i2c-mpc use it. As a matter of fact you
> > _are_ declaring a platform driver (.bus = &platform_bus_type), just not
> > using the standard way.
> >
> >   
> Standard way here - platform devices got registered from elsewhere - 
> from arch/ppc/ppc_sys.c if arch/ppc or from 
> arch/powerpc/sysdev/fsl_soc.c if powerpc.
> Every way (powerpc is more flexible since is pulling the information 
> from the firmware-passed device tree) fills in the resources and 
> platform data, and
> is capable with device/drive bound you are talking about.

This doesn't explain why you can't use platform_driver_register(),
which is the right way to register a platform driver.

-- 
Jean Delvare
