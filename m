Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYJ1GWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYJ1GWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 02:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYJ1GW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 02:22:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbYJ1GW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 02:22:28 -0400
Date: Mon, 27 Oct 2008 23:22:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH 2/2] rtc: rtc-wm8350: Add support for WM8350 RTC
Message-Id: <20081027232212.02626142.akpm@linux-foundation.org>
In-Reply-To: <1225121905-23782-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1225121905-23782-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1225121905-23782-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 15:38:25 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> This adds support for the RTC provided by the Wolfson Microelectronics
> WM8350.
> 
> This driver was originally written by Graeme Gregory and Liam Girdwood,
> though it has been modified since then to update it to current mainline
> coding standards and for API completeness.

Graeme doesn't seem to get a mention anywhere in the driver?

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> Updated to use schedule_timeout_uninterruptible() as per Andrew's
> suggestion.

You also did this:

--- a/drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-update
+++ a/drivers/rtc/rtc-wm8350.c
@@ -471,7 +471,7 @@ static int wm8350_rtc_probe(struct platf
 	return 0;
 }
 
-static int __exit wm8350_rtc_remove(struct platform_device *pdev)
+static int __devexit wm8350_rtc_remove(struct platform_device *pdev)
 {
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
 	struct wm8350_rtc *wm_rtc = &wm8350->rtc;
@@ -500,16 +500,15 @@ static int __init wm8350_rtc_init(void)
 {
 	return platform_driver_register(&wm8350_rtc_driver);
 }
+module_init(wm8350_rtc_init);
 
 static void __exit wm8350_rtc_exit(void)
 {
 	platform_driver_unregister(&wm8350_rtc_driver);
 }
-
-module_init(wm8350_rtc_init);
 module_exit(wm8350_rtc_exit);
 
-MODULE_AUTHOR("Liam Girdwood");
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("RTC driver WM8350");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:wm8350-rtc");
_



