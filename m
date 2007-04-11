Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXDKHM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXDKHM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbXDKHM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:12:29 -0400
Received: from gate.nentec.de ([217.91.74.44]:42021 "EHLO gate2.nentec.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750782AbXDKHM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:12:28 -0400
X-Greylist: delayed 1459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 03:12:27 EDT
From: Juergen Schindele <schindele@nentec.de>
Reply-To: schindele@nentec.de
Organization: NenTec GmbH
To: Paul Sokolovsky <pmiscml@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] gpiodev - API definitions
Date: Wed, 11 Apr 2007 08:47:01 +0200
User-Agent: KMail/1.5.4
References: <774343545.20070411003058@gmail.com>
In-Reply-To: <774343545.20070411003058@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704110847.01107.schindele@nentec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 10. April 2007 23:30 schrieb Paul Sokolovsky:
> Hello linux-arm-kernel,
>
> GPIODEV API: Core API definitions. Provided are:
> 1. struct gpiodev_ops which must be included into platform_data structure
> of a device which will provide GPIODEV API; driver for a device must
> initialize this structure.
> 2. Structural definition of generalized GPIO identifier (struct gpio).
> 2. Set of API calls for clients. This fully follow Generic GPIO API
> naming and semantics, except that they have "gpiodev" prefix and
> accept struct gpio instead of integer gpio identifiers.
>
>
> Index: include/linux/gpiodev.h
> ===================================================================
> RCS file: include/linux/gpiodev.h
> diff -N include/linux/gpiodev.h
> --- /dev/null   1 Jan 1970 00:00:00 -0000
> +++ include/linux/gpiodev.h     10 Apr 2007 19:17:12 -0000      1.5
> @@ -0,0 +1,43 @@
> +#ifndef __GPIODEV_H
> +#define __GPIODEV_H
> +
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <asm/gpio.h>
> +
> +/* Interface */
> +
> +/* This structure must be first member of device platform_data structure
> +   of a device which provides gpiodev interface */
> +struct gpiodev_ops {
> +        int (*get)(struct device *this, int gpio_no);
> +        void (*set)(struct device *this, int gpio_no, int val);
> +        int (*to_irq)(struct device *this, int gpio_no);
> +};
> +
> +/* Generalized GPIO structure */
> +
> +struct gpio {
> +       struct platform_device *gpio_dev;
> +       int gpio_no;
> +};
> +
> +/* API functions */
> +
> +static inline int gpiodev_get_value(struct gpio *gpio)
> +{
> +       struct gpiodev_ops *ops = gpio->gpio_dev->dev.platform_data;

wouldn't it be more sure to verify if xxx function is NOT null
before using it ?? Perhaps something like that
	     BUG_ON(!ops->get);

> +       return ops->get(&gpio->gpio_dev->dev, gpio->gpio_no);
> +}
> +static inline void gpiodev_set_value(struct gpio *gpio, int val)
> +{
> +       struct gpiodev_ops *ops = gpio->gpio_dev->dev.platform_data;
> +       ops->set(&gpio->gpio_dev->dev, gpio->gpio_no, val);
> +}
> +static inline int gpiodev_to_irq(struct gpio *gpio)
> +{
> +       struct gpiodev_ops *ops = gpio->gpio_dev->dev.platform_data;
> +       return ops->to_irq(&gpio->gpio_dev->dev, gpio->gpio_no);
> +}
> +
> +#endif /* __GPIODEV_H */

-- 
--------------------------------------------------------------
Jürgen Schindele  
Software-Entwicklung

NENTEC Netzwerktechnologie GmbH
Greschbachstr. 12
76229 Karlsruhe
Deutschland
Telefon: +49/721/94249-51
Telefax: +49/721/94249-10
E-Mail:  schindele@nentec.de
WEB:     www.nentec.de
 
Geschäftsführung: Klaus Becker, Roland Knapp
Sitz der Gesellschaft: Karlsruhe
Handelsregister: Amtsgericht Mannheim HRB 107658
 
Diese E-Mail enthält vertrauliche oder rechtlich geschützte Informationen.
Wenn Sie nicht der vorgesehene Empfänger sind, informieren Sie bitte sofort
den Absender und löschen Sie diese E-Mail. Das unbefugte Kopieren dieser E-Mail
oder die unbefugte Weitergabe der enthaltenen Informationen ist nicht gestattet.
 
The information contained in this message is confidential or protected by law.
If you are not the intended recipient, please contact the sender and delete this
message. Any unauthorised copying of this message or unauthorised distribution of
the information contained herein is prohibited.
--------------------------------------------------------------

