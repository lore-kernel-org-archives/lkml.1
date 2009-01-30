Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZA3ULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZA3ULU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZA3ULL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:11:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbZA3ULK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:11:10 -0500
Date: Fri, 30 Jan 2009 12:10:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 3/3] mfd: Improve diagnostics for WM8350 ID register
 probe
Message-Id: <20090130121009.6de9f11c.akpm@linux-foundation.org>
In-Reply-To: <1232727516-5049-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232727516-5049-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1232727516-5049-2-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1232727516-5049-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009 16:18:36 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> @@ -1297,14 +1297,29 @@ static void wm8350_client_dev_register(struct wm8350 *wm8350,
>  int wm8350_device_init(struct wm8350 *wm8350, int irq,
>  		       struct wm8350_platform_data *pdata)
>  {
> -	int ret = -EINVAL;
> +	int ret;
>  	u16 id1, id2, mask_rev;
>  	u16 cust_id, mode, chip_rev;
>  
>  	/* get WM8350 revision and config mode */
> -	wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
> -	wm8350->read_dev(wm8350, WM8350_ID, sizeof(id2), &id2);
> -	wm8350->read_dev(wm8350, WM8350_REVISION, sizeof(mask_rev), &mask_rev);
> +	ret = wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
> +	if (ret != 0) {
> +		dev_err(wm8350->dev, "Failed to read ID: %d\n", ret);
> +		goto err;
> +	}
> +
> +	ret = wm8350->read_dev(wm8350, WM8350_ID, sizeof(id2), &id2);

Reading a bunch of bytes into a u16 looks a bit fishy from the endianness
point of view?
