Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbYIDOny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbYIDOny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYIDOnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:43:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35721 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751733AbYIDOnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:43:45 -0400
Date: Thu, 4 Sep 2008 15:43:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>
Subject: Re: [PATCH 7/9] ASoC: Blackfin: I2S CPU DAI driver
Message-ID: <20080904144343.GB32531@rakim.wolfsonmicro.main>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	Cliff Cai <cliff.cai@analog.com>
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org> <1220516528-20301-8-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220516528-20301-8-git-send-email-cooloney@kernel.org>
X-Cookie: What is the sound of one hand clapping?
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 04:22:06PM +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Please fix the minor issues below as incremental patches for ease of
review.

> +	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
> +	case SND_SOC_DAIFMT_I2S:
> +		break;
> +	case SND_SOC_DAIFMT_LEFT_J:
> +		ret = -EINVAL;
> +		break;
> +	}

The SND_SOC_DAFIMT_LEFT_J: ought to be default: instead - there's more
DAI formats than just that.

> +	if (!bf5xx_i2s.master) {
> +	/*
> +	 * TX and RX are not independent,they are enabled at the same time,
> +	 * even if only one side is running.So,we need to configure both of
> +	 * them in advance.
> +	 *
> +	 * CPU DAI format:I2S, slave mode.
> +	 */

The indentation here is odd.  Also, is the expecation that this
configuration be done only once ever - nothing seems to clear the flag?
