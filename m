Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0BHVFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:05:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994Ab0BHVF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:05:29 -0500
Date: Mon, 8 Feb 2010 13:04:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Richard Purdie <rpurdie@linux.intel.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds-gpio: Fix default state handling on OF platforms
Message-Id: <20100208130455.8cb90ff1.akpm@linux-foundation.org>
In-Reply-To: <20100205205437.GA4733@oksana.dev.rtsoft.ru>
References: <20100205205437.GA4733@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010 23:54:37 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> The driver wrongly sets default state for LEDs that don't specify
> default-state property.
> 
> Currently the driver handles default state this way:
> 
> memset(&led, 0, sizeof(led));
> for_each_child_of_node(np, child) {
> 	state = of_get_property(child, "default-state", NULL);
> 	if (state) {
> 		if (!strcmp(state, "keep"))
> 			led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
> 		...
> 	}
> 	ret = create_gpio_led(&led, ...);
> }
> 
> Which means that all LEDs that do not specify default-state will
> inherit the last value of the default-state property, which is wrong.


Does this actually happen in any 2.6.33 driver code?  If so, we might
want to merge this into 2.6.33.  And perhaps earlier kernels.  Or not. 
There's no way for me to tell :(

