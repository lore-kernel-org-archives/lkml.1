Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZHVIQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZHVIQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 04:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbZHVIQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 04:16:42 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64642 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbZHVIQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 04:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jwXEqdJ6M1kVy/kzZ7mRcgfEwxoclu9z/hOv/hO0IWyHkgvDiryYcy3vA28WSIvcuc
         dYGMdavN3N0ZsVff9Cnl1dqQMs69gcS14ZAH12a4O2IKQcfsXw0KDLfj5HTYnw6oIuYe
         21X9FEQbP9lbyXUFQR6xXCxuNzQBj0GzMVf+g=
MIME-Version: 1.0
In-Reply-To: <200908220713.20637.elendil@planet.nl>
References: <200908220223.50588.marek.vasut@gmail.com>
	 <200908220713.20637.elendil@planet.nl>
Date: Sat, 22 Aug 2009 10:16:38 +0200
Message-ID: <f861ec6f0908220116x1322b65cs79695f54b97d8381@mail.gmail.com>
Subject: Re: [PATCH] Convert MMC subsys drivers to dev_pm_ops
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-arm-kernel@lists.infradead.org,
       nicolas.ferre@atmel.com, mirq-linux@rere.qmqm.pl,
       linux-kernel@vger.kernel.org, manuel.lauss@gmail.com, ppisa@pikron.com,
       nico@cam.org, maen@marvell.com, s.hauer@pengutronix.de,
       tony@atomide.com, madhu.cr@ti.com, drzeus@drzeus.cx,
       ben-linux@fluff.org, avorontsov@ru.mvista.com, pierre@ossman.eu,
       sdhci-devel@lists.ossman.eu, saschasommer@freenet.de, oakad@yahoo.com,
       ian@mnementh.co.uk, HaraldWelte@viatech.com, JosephChan@via.com.tw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Sat, Aug 22, 2009 at 7:13 AM, Frans Pop<elendil@planet.nl> wrote:
> Marek Vasut wrote:
>> +static struct dev_pm_ops cm710_mmc_pm_ops = {
>> +       .suspend = cb710_mmc_suspend,
>> +       .resume = cb710_mmc_resume,
>> +};
>
> This is almost certainly wrong (same for the other drivers you converted)
> as they now no longer support hibernation, which requires different ops.
> Please see: http://lkml.org/lkml/2009/7/25/118.
>
> You also seem to have handled the #ifndef CONFIG_PM case incorrectly.
> See http://lkml.org/lkml/2009/8/3/253 for an example how it can be done.

In addition to what Frans said, at least for platform drivers you could
avoid adding (mostly) unused platform_device temp vars like these

+       struct platform_device *pdev = to_platform_device(dev);
        struct au1xmmc_host *host = platform_get_drvdata(pdev);

by simply doing
-        struct au1xmmc_host *host = platform_get_drvdata(pdev);
+        struct au1xmmc_host *host = dev_get_drvdata(dev);

What do you think?

Thanks!
      Manuel Lauss
