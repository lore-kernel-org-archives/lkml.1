Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZC1JbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZC1JbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZC1JbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:31:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:22867 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZC1JbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L6iOdPlBD46rB0JVtEJ8J7Ltg11geweDJaY6NlmBrG/YHZePHX2iqyFM9AvBK85jFo
         um3oXMMbS8kWHDVNCTGCK9cgZZdB4oVDKS/0u/V4JYFcgIGGrvcbL11mtFxinEqWC41j
         sG1Aqdd7jBQXdAPWvb/Emcu7FZmmF/7czEZ9g=
MIME-Version: 1.0
In-Reply-To: <1238196439-16535-10-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	 <1238196439-16535-10-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Sat, 28 Mar 2009 17:31:05 +0800
Message-ID: <f17812d70903280231n4f4029a8m8f4dfe26e4168daa@mail.gmail.com>
Subject: Re: [PATCH 10/58] move corgi-ssp's probe function to .devinit.text
From: Eric Miao <eric.y.miao@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Eric Miao <eric.miao@marvell.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Sokolovsky <pmiscml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> A pointer to corgi_ssp_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (when having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
>
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
>

These files are supposed to be deprecated and I'm planning to remove
them once drivers/input/touchscreen/corgi-ts.c begins its migration to
ads7846.c (with a posted fix currently queued in the -mm tree). Other
than corgi-ts.c, there will be no reference to them.
