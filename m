Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZGNHIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZGNHIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 03:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZGNHIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 03:08:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61361 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbZGNHIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 03:08:41 -0400
Date: Tue, 14 Jul 2009 09:08:06 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard =?utf-8?Q?R=C3=B6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kwangwoo.lee@gmail.com, Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] tsc2007: remove HR timer
Message-ID: <20090714070806.GA1619@avionic-design.de>
References: <4A40C288.2060702@mocean-labs.com>
 <20090714044957.GD2822@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090714044957.GD2822@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1+lE9ZdBkEop5SeoPQYpE5XBS+LXZZ5tVCpw3P
 Tq0fcMjJzDuJo/CQQDD8cSt8Xn95DEJJK0QjSXq7pTaRkzFMAm
 1Rwkj4JOZUk+BnWfKxqpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dmitry Torokhov wrote:
> Hi Richard,
> 
> On Tue, Jun 23, 2009 at 01:54:48PM +0200, Richard Röjfors wrote:
[...]
> +static void tsc2007_free_irq(struct tsc2007 *ts)
> +{
> +	free_irq(ts->irq, ts);
> +	if (cancel_delayed_work_sync(&ts->work)) {
> +		/*
> +		 * Work was pending, therefore we need to enable
> +		 * IRQ here to balance the disable_irq() done in the
> +		 * interrupt handler.
> +		 */
> +		enable_irq(ts->irq);
> +	}
> +}
[...]
> -static int tsc2007_remove(struct i2c_client *client)
> +static int __devexit tsc2007_remove(struct i2c_client *client)
>  {
>  	struct tsc2007	*ts = i2c_get_clientdata(client);
> -	struct tsc2007_platform_data *pdata;
> +	struct tsc2007_platform_data *pdata = client->dev.platform_data;
>  
> -	cancel_delayed_work_sync(&ts->work);
> +	free_irq(ts->irq, ts);
> +	if (cancel_delayed_work_sync(&ts->work)) {
> +		/*
> +		 * Work was pending, therefore we need to enable
> +		 * IRQ here to balance the disabel done in the
> +		 * interrupt handler.
> +		 */
> +		enable_irq(ts->irq);
> +	}

Shouldn't this be tsc2007_free_irq(ts) as well?

Thierry
