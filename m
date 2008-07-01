Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbYGAVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbYGAVc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYGAVct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:32:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759543AbYGAVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:32:48 -0400
Date: Tue, 1 Jul 2008 14:32:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH] Add support for power_supply on tosa
Message-Id: <20080701143232.cca14c86.akpm@linux-foundation.org>
In-Reply-To: <20080620084917.GA20577@doriath.ww600.siemens.net>
References: <20080620084917.GA20577@doriath.ww600.siemens.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 12:49:17 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Support the battery management on Sharp Zaurus SL-6000.
> 
> This patch depends on the tc6393xb support as found in the arm:devel
> or linux-next trees.

Which means that Anton can't really merge it into his tree, I guess. 
I'll babysit it untilthe appropriate time.


> +static unsigned long tosa_read_bat(struct tosa_bat *bat)
> +{
> +	unsigned long value = 0;
> +
> +	if (bat->gpio_bat < 0 || bat->adc_bat < 0)
> +		return 0;
> +
> +	mutex_lock(&bat_lock);
> +	gpio_set_value(bat->gpio_bat, 1);
> +	mdelay(5);

msleep() is preferred over a busywait.

> +	value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
> +			bat->adc_bat);
> +	gpio_set_value(bat->gpio_bat, 0);
> +	mutex_unlock(&bat_lock);
> +
> +	value = value * 1000000 / bat->adc_bat_divider;
> +
> +	return value;
> +}
> +
> +static unsigned long tosa_read_temp(struct tosa_bat *bat)
> +{
> +	unsigned long value = 0;
> +
> +	if (bat->gpio_temp < 0 || bat->adc_temp < 0)
> +		return 0;
> +
> +	mutex_lock(&bat_lock);
> +	gpio_set_value(bat->gpio_temp, 1);
> +	mdelay(5);

ditto. (and elsewhere)

