Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0BIRNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:13:36 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:42094 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab0BIRNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:13:34 -0500
MIME-Version: 1.0
In-Reply-To: <20100205203236.GC1475@oksana.dev.rtsoft.ru>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru> <20100205203236.GC1475@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Feb 2010 10:13:11 -0700
X-Google-Sender-Auth: c2fdce183ff1a73a
Message-ID: <fa686aa41002090913t4c72a3b8o5fda68723bc8d089@mail.gmail.com>
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 1:32 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> This patch implements GPIOLIB notifier hooks, and thus makes device-enabled
> GPIO chips (i.e. the ones that have gpio_chip->dev specified) automatically
> attached to the OpenFirmware subsystem. Which means that now we can handle
> I2C and SPI GPIO chips almost* transparently.
>
> * "Almost" because some chips still require platform data, and for these
>  chips OF-glue is still needed, though with this support the glue will
>  be much smaller.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> +static struct notifier_block of_gpio_nb = {
> +       .notifier_call = of_gpio_notify,
> +};
> +
> +static int __init of_gpio_notifier_init(void)
> +{
> +       return blocking_notifier_chain_register(&gpio_notifier, &of_gpio_nb);
> +}
> +arch_initcall(of_gpio_notifier_init);

Another concern;  if any gpio chips get registered before this
arch_initcall (not sure if it is possible or not), then those chips
won't get registered with the of gpio infrastructure.

g.
