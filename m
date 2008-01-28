Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYA1Fdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYA1Fdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYA1FdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:33:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYA1FdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:33:04 -0500
Date: Sun, 27 Jan 2008 21:32:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>, Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org, David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH -mm 2/2] PWM LED driver
Message-Id: <20080127213232.ade044d5.akpm@linux-foundation.org>
In-Reply-To: <1201185225-15789-3-git-send-email-hskinnemoen@atmel.com>
References: <1201185225-15789-1-git-send-email-hskinnemoen@atmel.com>
	<1201185225-15789-2-git-send-email-hskinnemoen@atmel.com>
	<1201185225-15789-3-git-send-email-hskinnemoen@atmel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008 15:33:45 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> +	if (i > 0) {
> +		for (i = i - 1; i >= 0; i--) {
> +			led_classdev_unregister(&leds[i].cdev);
> +			pwm_channel_free(&leds[i].pwmc);
> +		}
> +	}

Could be:

	while (--i > 0) {
		led_classdev_unregister(&leds[i].cdev);
		pwm_channel_free(&leds[i].pwmc);
	}

or thereabouts.
