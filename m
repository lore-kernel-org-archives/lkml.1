Return-Path: <linux-kernel-owner+w=401wt.eu-S1751756AbYLCKEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbYLCKEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYLCKEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:04:12 -0500
Received: from tim.rpsys.net ([194.106.48.114]:36690 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYLCKEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:04:11 -0500
Subject: Re: leds/leds-pca9532.c: sleeping function called in
	.brightness_set()
From: Richard Purdie <rpurdie@rpsys.net>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0811241041130.4148@axis700.grange>
References: <Pine.LNX.4.64.0811241041130.4148@axis700.grange>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 10:03:27 +0000
Message-Id: <1228298607.9126.1.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 10:51 +0100, Guennadi Liakhovetski wrote:
> this seems to explicitly violate the API as documented in 
> include/linux/leds.h:
> 
> 	/* Set LED brightness level */
> 	/* Must not sleep, use a workqueue if needed */
> 	void		(*brightness_set)(struct led_classdev *led_cdev,
> 					  enum led_brightness brightness);
> 
> and also contradicts some other drivers, e.g., pca955x, which do use a 
> workqueue as suggested: leds-pca9532.c::pca9532_set_brightness uses a 
> mutex for locking and calls i2c_smbus functions directly. Needs to be 
> fixed (if it hasn't been fixed yet), probably, also vor 2.6.27-stable.

There is a patch queued to fix this now. I'll submit some fixes to
2.6.28-rcX shortly and then we can consider it for -stable.

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

