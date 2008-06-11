Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYFKIXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYFKIXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYFKIXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:23:17 -0400
Received: from 203-96-159-182.paradise.net.nz ([203.96.159.182]:41054 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753195AbYFKIXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:23:16 -0400
Message-ID: <48503432.6010105@bluewatersys.com>
Date: Thu, 12 Jun 2008 08:23:14 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
References: <200806091541.43899.u.luckas@road.de>	<484DA046.4010804@bluewatersys.com>	<20080610085708.12c2d2a2@hyperion.delvare>	<200806101355.07792.david-b@pacbell.net> <20080611101130.1a667abe@hyperion.delvare>
In-Reply-To: <20080611101130.1a667abe@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
>
> That's easier to get right if you restrict yourself to a single
> platform. For the vanilla kernel, the order of the dependencies is way
> more difficult to figure out and get right. There are some hints in
> drivers/Makefile but most dependencies aren't spelled out.
>
> My feeling is that we won't be able to solve this without first moving
> the different type of i2c bus drivers (and possibly chip drivers) to
> separate directories. For example, moving external I2C bus drivers
> (i2c-parport-light, i2c-parport, i2c-taos-evm and i2c-tiny-usb) to a
> separate directory that is always initialized late, would remove the
> dependencies on parport, serio and USB for the "must initialize i2c
> early" problem.
>
> I've already attempted a categorization of the i2c bus drivers:
> http://lists.lm-sensors.org/pipermail/i2c/2008-May/003713.html
> http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/i2c-group-bus-drivers.patch
> I would welcome comments on this, and suggestions for further
> categorization of group "other".
>   
I like this idea. Is it possible to move (or mark as subsys_initcall) the
i2c busses which are likely to be needed early: pxa, omap, gpio, etc and
leave the PC/external busses alone. Then having the i2c chip drivers in
the correct place (ie drivers/gpio) would effectively fix the problem.

~Ryan

