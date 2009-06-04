Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZFDHyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZFDHyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZFDHyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:54:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbZFDHyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:54:40 -0400
Date: Thu, 4 Jun 2009 00:54:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
Message-Id: <20090604005435.d3671419.akpm@linux-foundation.org>
In-Reply-To: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Jun 2009 04:16:59 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

-ENOCHANGELOGAGAIN

> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 51a8d41..7f79732 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -274,7 +274,12 @@ static ssize_t gpio_value_store(struct device *dev,
>  	else {
>  		long		value;
>  
> -		status = strict_strtol(buf, 0, &value);
> +		if (sysfs_streq(buf, "toggle")) {
> +			value = !gpio_get_value_cansleep(gpio);
> +			status = 0;
> +		} else
> +			status = strict_strtol(buf, 0, &value);
> +
>  		if (status == 0) {
>  			gpio_set_value_cansleep(gpio, value != 0);
>  			status = size;

A suitable place to document this is Documentation/gpio.txt.
