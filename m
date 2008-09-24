Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYIXFJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYIXFJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYIXFJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:09:14 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:31994 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750991AbYIXFJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:09:13 -0400
Date: Wed, 24 Sep 2008 14:08:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexey Kopytko <alexey@kopytko.ru>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: Add platform data structure to Ricoh RS5C372 driver
Message-ID: <20080924050809.GA6722@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Alexey Kopytko <alexey@kopytko.ru>,
	Alessandro Zummo <a.zummo@towertech.it>,
	linux-kernel@vger.kernel.org
References: <a700c9740809231945j643b226fv30d87521045078b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a700c9740809231945j643b226fv30d87521045078b1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:45:49AM +0900, Alexey Kopytko wrote:
> From: Alexey Kopytko <alexey@kopytko.ru>
> 
> This patch enables a platform developer to choose which alarm register to use.
> It adds and properly initializes platform data structure.
> 
> ---
> RS5C_REG_ALARM_B_MIN is used to store power state in
> Buffalo Linkstation Mini and some other Linkstations.
> Tested with and without platform data.
> 
> Signed-off-by: Alexey Kopytko <alexey@kopytko.ru>
> 
[snip]

> +#ifndef _LINUX_RTC_RS5C372_H_
> +#define _LINUX_RTC_RS5C372_H_
> +
> +#define RS5C_REG_ALARM_A_MIN	8			/* or ALARM_W */
> +#define RS5C_REG_ALARM_A_HOURS	9
> +#define RS5C_REG_ALARM_A_WDAY	10
> +
> +#define RS5C_REG_ALARM_B_MIN	11			/* or ALARM_D */
> +#define RS5C_REG_ALARM_B_HOURS	12
> +#define RS5C_REG_ALARM_B_WDAY	13			/* (ALARM_B only) */
> +
> +struct rs5c_plat_data {
> +	/* What alarm regs to use */
> +	int alarm_min;
> +	int alarm_hours;
> +};

I don't think this is a meaningful abstraction. Pushing this sort of
knowledge in to the platform code is pretty ugly, especially when the
only distinction you need is whether to use the A set or the B set.

Given that, you could simply have a flags field in the platform data and
use one bit to test in the driver for using the B set of registers (A is
always the default otherwise).
