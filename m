Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZGLAhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZGLAhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 20:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZGLAhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 20:37:01 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56452 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZGLAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 20:37:00 -0400
Date: Sun, 12 Jul 2009 01:36:56 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Weiwei Wang <weiwei.wang@windriver.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move sb1250-mac's probe function to .devinit.text
In-Reply-To: <1247345591-22643-30-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0907120135500.13862@eddie.linux-mips.org>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-18-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-21-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-22-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-23-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-24-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-25-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-26-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-27-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-28-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-29-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-30-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009, Uwe Kleine-K?nig wrote:

> A pointer to sbmac_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 
> Signed-off-by: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
> Cc: Weiwei Wang <weiwei.wang@windriver.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Maciej W. Rozycki <macro@linux-mips.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/net/sb1250-mac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Fine by me, thanks.

  Maciej
