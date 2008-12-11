Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYLKVfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYLKVfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758442AbYLKVew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:34:52 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:41926 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbYLKVev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:34:51 -0500
Date: Thu, 11 Dec 2008 13:33:51 -0800 (PST)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>, devicetree-discuss@ozlabs.org,
       Grant Likely <grant.likely@secretlab.ca>,
       Sean MacLennan <smaclennan@pikatech.com>
Subject: Re: [PATCH 1/4] leds: Support OpenFirmware led bindings
In-Reply-To: <20081210163217.GA20150@oksana.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.64.0812111326480.28806@t2.domain.actdsltmp>
References: <1228923703-16370-1-git-send-email-tpiepho@freescale.com>
 <20081210163217.GA20150@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, Anton Vorontsov wrote:
>> +	gpio_direction_output(led_dat->gpio, led_dat->active_low);
>
> This can fail (yeah, the original code didn't check return value
> either).

I've added a check.

>> +		unsigned int flags;
>
> I think it would be better to use `enum of_gpio_flags' type here,
> just for clarity.

You're right, I forgot to change this after the of_get_gpio patch was
changed.

>> +		ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
>> +				      &ofdev->dev, NULL);
>> +		if (ret < 0)
>
> of_node_put(np); is missing here.

of_node_put(child) you mean.  It's easy to forget this when one exits one
of these iterators early, since there's no explicit get or put otherwise.
