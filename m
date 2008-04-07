Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbYDGUQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbYDGUQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYDGUQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:16:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:1429 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYDGUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=dyGu8IfXWsXzF4QQaLc36W26EH4cJSobFCfC+NDcscSpKcqT7+Kz0iaoeV0f00r5YBAwELMSbfiBAsQBfKZSutVRdE3XXKiDoVfNIoHb9htk6+nAWeNNPoldnZOlJqkmyzkRS0zbwKIXu7v9ZwjiR988MV8TNDBUC4tQYTeWC6A=
Date: Mon, 7 Apr 2008 16:16:05 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bryan Wu <bryan.wu@analog.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/1] Input/Touchscreen Driver: add support AD7877
	touchscreen driver
Message-ID: <20080407161007.ZZRA012@mailhub.coreip.homeip.net>
References: <1202980649-13309-1-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202980649-13309-1-git-send-email-bryan.wu@analog.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan, Michael,

On Thu, Feb 14, 2008 at 05:17:28PM +0800, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> [try #3] Changlog (Add feedback from Dmitry Torokhov):
>  - Change handling of spi_sync / spi_async return value handling
>  - Remove depreciated dev->power.power_state
>  - Fix error return path in ad7877_probe
>  - delete pending kernel timer
>  - Some minor cleanup (indention, use dev_err etc.)

Sorry for the long silence... I have a couple of comments at the moment
but I am sure i will have more ;)

> +
> +	status = spi_sync(spi, &req->msg);
> +
> +	if (status == 0)
> +		status = req->msg.status;
> +
> +	kfree(req);
> +	return status ? status : req->sample;

Use after free here.

> +
> +	ts->irq_disabled = 1;
> +	disable_irq(spi->irq);

I am a bit uneasy here... do we need to wait for an async spi completion
here before proceeding? Overall I have some concerns about the
irq/spi/removal/sysfs iteractions, I will need some more time to look
through the driver.

> +	status = spi_sync(spi, &req->msg);
> +	ts->irq_disabled = 0;
> +	enable_irq(spi->irq);
> +

-- 
Dmitry
