Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZJVQ4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZJVQ4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZJVQ4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:56:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46361 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755595AbZJVQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:56:41 -0400
Date: Thu, 22 Oct 2009 17:56:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com, linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH 4/4 v2] ASoC: TWL4030: Driver registration via
 twl4030_codec MFD
Message-ID: <20091022165643.GA28051@rakim.wolfsonmicro.main>
References: <1256207208-25010-1-git-send-email-peter.ujfalusi@nokia.com>
 <1256207208-25010-2-git-send-email-peter.ujfalusi@nokia.com>
 <1256207208-25010-3-git-send-email-peter.ujfalusi@nokia.com>
 <1256207208-25010-4-git-send-email-peter.ujfalusi@nokia.com>
 <1256207208-25010-5-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256207208-25010-5-git-send-email-peter.ujfalusi@nokia.com>
X-Cookie: I had pancake makeup for brunch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 01:26:48PM +0300, Peter Ujfalusi wrote:
> Change the way how the twl4030 soc codec driver is
> loaded/probed.
> Use the device probing via tlw4030_codec MFD device.

I'm OK with the series but:

> @@ -147,6 +147,7 @@ config SND_SOC_TLV320DAC33
>  	tristate
> 
>  config SND_SOC_TWL4030
> +	select TWL4030_CODEC
>  	tristate

due to Kconfig ignoring dependencies all the individual machine drivers
are going to need to select this, and SND_SOC_ALL_CODECS will need to
select it if the MFD core is enabled.  I should be able to fix this up
myself so no need to repost for that alone.
