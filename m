Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZKBRad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZKBRad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZKBRac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:30:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36002 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750816AbZKBRab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:30:31 -0500
Date: Mon, 2 Nov 2009 17:30:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com, linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH 3/5] MFD: twl4030-codec: APLL_INFREQ handling in the
 MFD driver
Message-ID: <20091102173035.GC8546@rakim.wolfsonmicro.main>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-2-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-3-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-4-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257165295-9352-4-git-send-email-peter.ujfalusi@nokia.com>
X-Cookie: Humpty Dumpty was pushed.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 02:34:53PM +0200, Peter Ujfalusi wrote:
> Move the APLL_CTL register configuration to the twl4030-codec
> MFD driver.
> Provide also a function for childs to query the audio_mclk
> frequency.

This all looks good to me, some nitpicks below.

> +unsigned int twl4030_codec_get_mclk(void)
> +{
> +	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
> +
> +	return codec->audio_mclk;
> +}
> +EXPORT_SYMBOL_GPL(twl4030_codec_get_mclk);

As I said in my followup to patch 5 this feels like it should have a
parameter to specify the twl4030 though in practical systems it won't
matter.

> +	if (!(pdata->audio_mclk == 19200000 ||
> +	      pdata->audio_mclk == 26000000 ||
> +	      pdata->audio_mclk == 38400000)) {
> +		dev_err(&pdev->dev, "Invalid audio_mclk\n");
> +		return -EINVAL;
> +	}

Might flow more naturally with a switch statement?
