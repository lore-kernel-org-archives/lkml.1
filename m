Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbZHVFNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbZHVFNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 01:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932377AbZHVFNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 01:13:20 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:53380 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932302AbZHVFNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 01:13:20 -0400
From: Frans Pop <elendil@planet.nl>
To: Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] Convert MMC subsys drivers to dev_pm_ops
Date: Sat, 22 Aug 2009 07:13:16 +0200
User-Agent: KMail/1.9.9
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
       mirq-linux@rere.qmqm.pl, linux-kernel@vger.kernel.org,
       manuel.lauss@gmail.com, ppisa@pikron.com, nico@cam.org,
       maen@marvell.com, s.hauer@pengutronix.de, tony@atomide.com,
       madhu.cr@ti.com, drzeus@drzeus.cx, ben-linux@fluff.org,
       avorontsov@ru.mvista.com, pierre@ossman.eu, sdhci-devel@lists.ossman.eu,
       saschasommer@freenet.de, oakad@yahoo.com, ian@mnementh.co.uk,
       HaraldWelte@viatech.com, JosephChan@via.com.tw
References: <200908220223.50588.marek.vasut@gmail.com>
In-reply-To: <200908220223.50588.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908220713.20637.elendil@planet.nl>
X-OriginalArrivalTime: 22 Aug 2009 05:13:21.0349 (UTC) FILETIME=[44612F50:01CA22E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Vasut wrote:
> +static struct dev_pm_ops cm710_mmc_pm_ops = {
> +       .suspend = cb710_mmc_suspend,
> +       .resume = cb710_mmc_resume,
> +};

This is almost certainly wrong (same for the other drivers you converted) 
as they now no longer support hibernation, which requires different ops.
Please see: http://lkml.org/lkml/2009/7/25/118.

You also seem to have handled the #ifndef CONFIG_PM case incorrectly.
See http://lkml.org/lkml/2009/8/3/253 for an example how it can be done.

There have already been several threads on lkml discussing this. Please 
search for posts with dev_pm_ops in the subject if you want more 
information.

Also, please CC linux-pm@lists.linux-foundation.org on patches related to 
this conversion.

Cheers,
FJP
