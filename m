Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZF3G56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZF3G56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZF3G5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:57:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33402 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZF3G5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:57:50 -0400
Date: Tue, 30 Jun 2009 08:57:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, pierre@ossman.eu, swetland@google.com,
       Andrew Morton <akpm@linux-foundation.org>, San Mehat <san@google.com>
Subject: Re: [PATCH 0/3] msm_sdcc: A few more cleanups
Message-ID: <20090630065747.GA19260@elf.ucw.cz>
References: <20090629214101.GA12043@elf.ucw.cz> <cover.1246319479.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1246319479.git.joe@perches.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Perhaps these are appropriate as well.
> Uncompiled, I haven't set up an ARM cross compiler yet.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> Joe Perches (3):
>   msm_sdcc.c: Convert printk(KERN_<level> to pr_<level>(
>   msm_sdcc.c: stylistic cleaning
>   msm_sdcc.c: Move overly indented code to separate function

They look good, but break compilation. With these fixes, it compiles &
boots. Thanks!

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 010f4f4..6644cda 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -321,7 +321,7 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data)
 	memset(&host->pio, 0, sizeof(host->pio));
 
 	clks = (unsigned long long)data->timeout_ns * host->clk_rate;
-	do_div(clks, NSECS_PER_SEC);
+	do_div(clks, NSEC_PER_SEC);
 	timeout = data->timeout_clks + (unsigned int)clks;
 	writel(timeout, base + MMCIDATATIMER);
 
@@ -588,6 +588,8 @@ static void
 msmsdcc_handle_irq_data(struct msmsdcc_host *host, struct mmc_data *data,
 			u32 status)
 {
+	void __iomem	*base = host->base;
+
 	/* Check for data errors */
 	if (status & (MCI_DATACRCFAIL | MCI_DATATIMEOUT | 
 		      MCI_TXUNDERRUN | MCI_RXOVERRUN)) {


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
