Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZFVK5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZFVK5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 06:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZFVK50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 06:57:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40435 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbZFVK50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 06:57:26 -0400
Date: Mon, 22 Jun 2009 11:57:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?utf-8?B?5a6L5a6d5Y2O?= <21cnbao@gmail.com>
Cc: lrg@slimlogic.co.uk, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] New ASoC Drivers for ADI AD1938 codec
Message-ID: <20090622105727.GA29144@opensource.wolfsonmicro.com>
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com> <20090619104738.GF5270@sirena.org.uk> <3c17e3570906212008n6071e987sbcd4b9377364ae78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c17e3570906212008n6071e987sbcd4b9377364ae78@mail.gmail.com>
X-Cookie: Don't get to bragging.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:08:27AM +0800, 宋宝华 wrote:

[Please reply in-line, interspersing your new text into the message
you're replying to - it makes the discussion much easier to follow.]

> Hi Mark,
> ***For the new DAI format
> According to I2S spec, it doesn't definite a I2S with TDM as a standard I2S.
> http://www.nxp.com/acrobat_download/various/I2SBUS.pdf

It's a de facto standard - several other vendors implement TDM in
exactly the same fashion.  If you think about it this is a natural way
to handle TDM in I2S.

> It looks like you are admitting this kind of timing into I2S DAI too:
> http://i3.6.cn/cvbnm/8f/3d/08/268a4560e0daa1b41d69b82419da06e1.jpg
> I think I can follow it too.

The timing you're showing there is essentially a DSP mode with the left
and right channels alternating rather than an I2S style where the
polarity of the LRCLK signal indicates if the data transmitted at the
same time is for the left or right channel.  I'd need to think about it
in slightly more detail but probably it is actually a DSP mode - with
the DSP modes only one edge of the frame sync is used so the other edge
can be anywhere else within the frame.

> Due to my test boards, at present, the AD1938 is working in and supporting
> TDM timing like the diagram:
> http://i3.6.cn/cvbnm/2f/e2/f2/03ae2b51c4e90749972e70bf887f926f.jpg
> It looks like DSP mode with TDM, so can I path related codes into
> SND_SOC_DAIFMT_DSP switch?

Yes, that's DSP mode.

> ***For volume controls based on stereo pairs
> Even though DAC1-DAC8 are named as DACL1,DACR1, DACL2,DACR2..., but the
> DACLx and DACRx are not always in a pair, in fact, they are independent. As
> a codec supporting 8 channels, it can be configed into 2, 2.1, 4.1, 5.1,
> 6.1, 7.1, how to handle the pairs?

That's fairly standard and not really a practical problem.  Since
applications can address each channel of a stereo control independantly
they don't loose any control from grouping the channels together.
Having the stereo controls just makes it a bit easier when they are used
that way.
