Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZFIPSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZFIPSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZFIPSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:18:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44539 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753684AbZFIPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:18:33 -0400
Date: Tue, 9 Jun 2009 16:18:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: regulator_register() API
Message-ID: <20090609151834.GA30774@rakim.wolfsonmicro.main>
References: <20090609135947.GB18591@gundam.enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609135947.GB18591@gundam.enneenne.com>
X-Cookie: Well begun is half done.
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 03:59:47PM +0200, Rodolfo Giometti wrote:

> Current regulator_register() implementation forces the caller to
> allocate a proper device for each regulators and also the line:

>    struct regulator_init_data *init_data = dev->platform_data;

> forces the user to define the pointer platform_data as a "struct
> regulator_init_data" only.

That's not the case in current mainline - the init data is passed in as
an argument to regulator_register().  There should be no requirement
that the struct device be unique, you should be able to use the same
struct device for all the regulators on the device.  It's mostly just
used for printk.

> However if the regulator_register() worked in a similar way to
> led_classdev_register(), I simply can do something like this:

>         for (i = 0; i < regulators_num; i++) {
> 	       /* init regulators structs */
> 	       ...
> 
>                ret = regulator_register(&client->dev, &reg[i].dev);
>                if (ret < 0)
> 		       dev_warn(&client->dev, "unable to register\n");
>         }

You can do exactly this in current mainline.  You do need to supply init
data for each regulator to make them useful.  The change came in commit
0527100fd11d9710c7e153d791da78824b7b46fa which was merged during the
2.6.30 merge window.

> This will keep backward compatibility with old drivers and may offer a
> more versatile way to define a regulator expecially for
> multifunctional devices.

Most of the regulators currently supported are part of multi-function
devices so they're not an unusual case here.  
