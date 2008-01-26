Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYAZJ6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYAZJ6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYAZJ6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:58:44 -0500
Received: from main.gmane.org ([80.91.229.2]:48256 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbYAZJ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:58:43 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
Date: Sat, 26 Jan 2008 09:58:28 +0000 (UTC)
Message-ID: <fnf084$ju9$1@ger.gmane.org>
References: <20080121152402.GA7518@rakim.wolfsonmicro.main>
	<1200929100-17224-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp78-37-18-87.pppoe.avangarddsl.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-input@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Mark Brown wrote:

> +#ifdef CONFIG_PM
> +int wm97xx_resume(struct device *dev)
> +{
> +	struct wm97xx *wm = dev_get_drvdata(dev);
> +
> +	/* restore digitiser and gpios */
> +	if (wm->id == WM9713_ID2) {
> +		wm97xx_reg_write(wm, AC97_WM9713_DIG1, wm->dig[0]);
> +		wm97xx_reg_write(wm, 0x5a, wm->misc);
> +		if (wm->ts_use_count) {
> +			u16 reg;
> +			reg = wm97xx_reg_read(wm, AC97_EXTENDED_MID) & 0x7fff;
> +			wm97xx_reg_write(wm, AC97_EXTENDED_MID, reg);
> +		}
> +	}

Won't compile as there is no ts_use_count in struct wm97xx.

-- 
With best wishes
Dmitry


