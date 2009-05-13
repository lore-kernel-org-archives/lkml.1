Return-Path: <linux-kernel-owner+w=401wt.eu-S1761699AbZEMWOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761699AbZEMWOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbZEMWOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:14:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbZEMWOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:14:31 -0400
Date: Wed, 13 May 2009 15:14:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tobias_Mueller@twam.info
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
       Constantin Baranov <const@mimas.ru>
Subject: Re: [PATCH 001/001] leds: alix-leds2 fixed for Award BIOS
Message-Id: <20090513151415.6e84fd82.akpm@linux-foundation.org>
In-Reply-To: <17be05570905130710s1192729cqafa09127f6c34bf9@mail.gmail.com>
References: <17be05570905130710s1192729cqafa09127f6c34bf9@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 16:10:27 +0200
Tobias M__ller <Tobias_Mueller@twam.info> wrote:

> From: Tobias Mueller <Tobias_Mueller@twam.info>
> 
> Added initialisation of GPIO ports for compatibility with boards with Award
> BIOS (e.g. ALIX.3D3).
> Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>
> ---
> diff --git a/drivers/leds/leds-alix2.c b/drivers/leds/leds-alix2.c
> index ddbd773..bda9403 100644
> --- a/drivers/leds/leds-alix2.c
> +++ b/drivers/leds/leds-alix2.c
> @@ -14,7 +14,7 @@
> 
>  static int force = 0;
>  module_param(force, bool, 0444);
> -MODULE_PARM_DESC(force, "Assume system has ALIX.2 style LEDs");
> +MODULE_PARM_DESC(force, "Assume system has ALIX.2/ALIX.3 style LEDs");
> 
>  struct alix_led {
>  	struct led_classdev cdev;
> @@ -155,6 +155,11 @@ static int __init alix_led_init(void)
>  		goto out;
>  	}
> 
> +	/* enable output on GPIO for LED 1,2,3 */
> +	outl(1 << 6, 0x6104);
> +	outl(1 << 9, 0x6184);
> +	outl(1 << 11, 0x6184);
> +
>  	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
>  	if (!IS_ERR(pdev)) {
>  		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);

Will this cause problems on boards which are _not_ running that BIOS?

IOW, is this change backward-compatible?
