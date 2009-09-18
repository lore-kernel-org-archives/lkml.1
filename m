Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZIRDip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZIRDip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 23:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZIRDio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 23:38:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbZIRDin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 23:38:43 -0400
Date: Thu, 17 Sep 2009 20:38:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alek Du <alek.du@intel.com>
Cc: "david-b@pacbell.net" <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v3] gpio: add Intel Moorestown Platform Langwell chip
 gpio driver
Message-Id: <20090917203826.e083746d.akpm@linux-foundation.org>
In-Reply-To: <20090918091844.6c8a8bd1@dxy.sh.intel.com>
References: <20090703210706.41288a2a@dxy.sh.intel.com>
	<20090917163644.4783a337.akpm@linux-foundation.org>
	<20090918091844.6c8a8bd1@dxy.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 09:18:44 +0800 Alek Du <alek.du@intel.com> wrote:

> Sorry for the inconvenience. I do not have SPARC64 build env., but I think this patch will fix the build issue, I should include <linux/irq.h> by explicit.
> 
> >From 5f0f166b37c4313c27de32f6f200bbd0656603b7 Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Fri, 18 Sep 2009 09:09:19 +0800
> Subject: [PATCH] gpio: Fix Langwell gpio driver build error
> 
> Need to include <linux/irq.h> directly ...
> 
> Signed-off-by: Alek Du <alek.du@intel.com>
> ---
>  drivers/gpio/langwell_gpio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
> index e100583..10a1172 100644
> --- a/drivers/gpio/langwell_gpio.c
> +++ b/drivers/gpio/langwell_gpio.c
> @@ -27,6 +27,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/io.h>
> +#include <linux/irq.h>
>  #include <linux/gpio.h>
>  
>  struct lnw_gpio_register {
	
include/linux/irq.h says

/*
 * Please do not include this file in generic code.  There is currently
 * no requirement for any architecture to implement anything held
 * within this file.
 *
 * Thanks. --rmk
 */

but

y:/usr/src/linux-2.6.31> grep -rl 'linux/irq.h' drivers | wc -l
101

Russell, is that rule no longer true?

Thanks.
