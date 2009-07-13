Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZGMIoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZGMIoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 04:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbZGMIoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 04:44:14 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:49691 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbZGMIoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 04:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oWRHZ4fAUHw3H4yeqpAoddeuvNhKo72cOeywH6dshFiXEiJjH+jP4cwplmUk2uocUH
         WyCNUs6lMI4ZsOkdlqz+d4kWyF7hzn6X++EruHGMkUSQDcnDKUulJbJBYwXR6iLuaSN/
         a16ai6bCFhrH57EUuhLg6Yom5/2M4bZkSiV+0=
Message-ID: <4A5AF3D1.7080802@gmail.com>
Date: Mon, 13 Jul 2009 16:44:01 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Eric Miao <eric.miao@marvell.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Sokolovsky <pmiscml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move corgi-ssp's probe function to .devinit.text
References: <20090711170548.GC5205@suse.de> <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-5-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-6-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-7-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> A pointer to corgi_ssp_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (when having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 

This corgi_ssp.c and corgi_lcd.c will be obsoleted soon, the only user
corgi_ts.c has been marked as deprecated, and will be remove once the
ssp cleanup work is done, so further fixes to these files are pointless.
