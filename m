Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZC1IWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZC1IWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 04:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZC1IWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 04:22:01 -0400
Received: from tservice.net.ru ([195.178.208.66]:33188 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbZC1IWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 04:22:00 -0400
Date: Sat, 28 Mar 2009 11:21:49 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Stanley.Miao" <stanley.miao@windriver.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 31/58] move omap_hdq's probe function to .devinit.text
Message-ID: <20090328082148.GA20668@ioremap.net>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-31-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238196439-16535-31-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe.

On Sat, Mar 28, 2009 at 12:26:52AM +0100, Uwe Kleine-König (u.kleine-koenig@pengutronix.de) wrote:
> A pointer to omap_hdq_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

I wonder if it can be hotplugged, but for the consistency it looks good.

-- 
	Evgeniy Polyakov
