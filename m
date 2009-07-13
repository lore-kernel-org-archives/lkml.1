Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZGMJPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZGMJPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZGMJPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:15:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42710 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754939AbZGMJPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:15:41 -0400
Date: Mon, 13 Jul 2009 10:15:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?utf-8?B?5a6L5a6d5Y2O?= <21cnbao@gmail.com>
Cc: lrg@slimlogic.co.uk, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] New ASoC Drivers for ADI AD1938 codec
Message-ID: <20090713091538.GA6987@rakim.wolfsonmicro.main>
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com>
 <20090619104738.GF5270@sirena.org.uk>
 <3c17e3570907130112i128dd0f2o4673200de3125d5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c17e3570907130112i128dd0f2o4673200de3125d5d@mail.gmail.com>
X-Cookie: Vote anarchist.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 04:12:14PM +0800, 宋宝华 wrote:

> I want to use ADC/DAC widgets.
> static const struct snd_soc_dapm_widget ad1938_dapm_widgets[] = {
>         SND_SOC_DAPM_DAC("DAC", "HiFi Playback", AD1938_DAC_CTRL0, 0, 1),
>         SND_SOC_DAPM_ADC("ADC", "HiFi Capture", AD1938_ADC_CTRL0, 0, 1),
> };
> But for this AD1938 codec, DAC's work depends on ADC is powered on in
> hardware.  I think there is no any mechanism to handle this kind of
> strange depending now.  So is there a generic way to handle this?

Make the ADC power a SND_SOC_DAPM_SUPPLY() supplying both the DAC and
the ADC, with the ADC widget marged as having no power management.
