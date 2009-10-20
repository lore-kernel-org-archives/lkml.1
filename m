Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbZJTLbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbZJTLbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 07:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZJTLbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 07:31:09 -0400
Received: from smtp.nokia.com ([192.100.122.233]:38791 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZJTLbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 07:31:07 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 4/4] ASoC: TWL4030: Driver registration via twl4030_codec MFD
Date: Tue, 20 Oct 2009 14:30:49 +0300
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "tony@atomide.com" <tony@atomide.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-5-git-send-email-peter.ujfalusi@nokia.com> <20091020102540.GB28592@opensource.wolfsonmicro.com>
In-Reply-To: <20091020102540.GB28592@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910201430.49223.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 20 Oct 2009 11:30:49.0946 (UTC) FILETIME=[C65E13A0:01CA5178]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 October 2009 13:25:40 ext Mark Brown wrote:
> On Mon, Oct 19, 2009 at 03:42:20PM +0300, Peter Ujfalusi wrote:
> > TWL4030 codec is now using the device registration via
> > tlw4030_codec MFD device.
> 
> This looks pretty good but obviously depends on the MFD changes.

Thanks, yes it all depends on the MFD changes.

> The major thing that jumps out at me is the removal of the register
> definitions from the ASoC headers - it might be nice to have that done
> as part of the MFD patch, or as a separate patch.

The reason why I have done it like this is that with one patch I only touch one 
subsystem at the time:
1. MFD changes only
2. OMAP related changes
3. soc codec driver change

In patch 1, the register definitions had to be added, so that the twl4030_codec 
driver knows the registers (and there could be the vibra driver placed 
separately from the soc codec driver).
In patch 3, where I modify the soc codec driver to use the new method, than I 
remove the definitions and use the existing header file, introduced by the first 
patch.
All in all, after each patch the kernel can be builds, boots and works as 
before.

> 
> You've also got the bias being brought up when the ASoC system comes up
> rather than when the driver comes up.  To be honest it doesn't really
> make any difference either way, it's just slightly different to other
> drivers.

I was thinking that if you built the kernel with SND_SOC_ALL_CODECS on OMAP 
platform for some reason and you don't actually use the twl4030 as audio device 
-> no machine driver, which would use it, than the codec part would be off.
But yes, probably I can move the povering up to the probe function.

> What is useful with things like twl4030 which take a little
> while to come up is if you can do the bias bringup out of line from
> device probe, avoiding blocking system startup on CODEC bringup.  That's
> definitely a separate patch, I'm just mentioning it for interest here.

I'm sure there will be another round for this series, so I can make this change 
at the same time within the patch, since this anyway changes the way how the 
driver is loaded/probed.

> 
> There's also a couple of debug prints (like in the remove function) and

I'll get rid of them.
But at least this time I did not had those unneeded casts, which I usually have 
;)

> 
> > +MODULE_ALIAS("platform:twl4030_codec:audio");
> 
> Is that second colon right given...

I'm not sure about it at all either. I did not found any other 'nested MFD' 
drivers around, so this is just a guess
Should it be:

 +MODULE_ALIAS("platform:twl4030_codec_audio");


> 
> > +	.driver		= {
> > +		.name	= "twl4030_codec_audio",
> > +		.owner	= THIS_MODULE,
> 
> this.
> 

-- 
Péter
