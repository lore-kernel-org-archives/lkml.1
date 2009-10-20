Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbZJTKZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbZJTKZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 06:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZJTKZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 06:25:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51340 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750806AbZJTKZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 06:25:36 -0400
Date: Tue, 20 Oct 2009 11:25:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, sameo@linux.intel.com, tony@atomide.com
Subject: Re: [PATCH 4/4] ASoC: TWL4030: Driver registration via
	twl4030_codec MFD
Message-ID: <20091020102540.GB28592@opensource.wolfsonmicro.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-3-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-4-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-5-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255956140-4829-5-git-send-email-peter.ujfalusi@nokia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 03:42:20PM +0300, Peter Ujfalusi wrote:
> TWL4030 codec is now using the device registration via
> tlw4030_codec MFD device.

This looks pretty good but obviously depends on the MFD changes.  The
major thing that jumps out at me is the removal of the register
definitions from the ASoC headers - it might be nice to have that done
as part of the MFD patch, or as a separate patch.

You've also got the bias being brought up when the ASoC system comes up
rather than when the driver comes up.  To be honest it doesn't really
make any difference either way, it's just slightly different to other
drivers.  What is useful with things like twl4030 which take a little
while to come up is if you can do the bias bringup out of line from
device probe, avoiding blocking system startup on CODEC bringup.  That's
definitely a separate patch, I'm just mentioning it for interest here.

There's also a couple of debug prints (like in the remove function) and

> +MODULE_ALIAS("platform:twl4030_codec:audio");

Is that second colon right given...

> +	.driver		= {
> +		.name	= "twl4030_codec_audio",
> +		.owner	= THIS_MODULE,

this.
