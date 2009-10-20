Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZJTLvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZJTLvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 07:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbZJTLvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 07:51:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36769 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751095AbZJTLvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 07:51:04 -0400
Date: Tue, 20 Oct 2009 12:51:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH 4/4] ASoC: TWL4030: Driver registration via
 twl4030_codec MFD
Message-ID: <20091020115106.GB2909@rakim.wolfsonmicro.main>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
 <1255956140-4829-5-git-send-email-peter.ujfalusi@nokia.com>
 <20091020102540.GB28592@opensource.wolfsonmicro.com>
 <200910201430.49223.peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910201430.49223.peter.ujfalusi@nokia.com>
X-Cookie: Real programs don't eat cache.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 02:30:49PM +0300, Peter Ujfalusi wrote:

> In patch 1, the register definitions had to be added, so that the twl4030_codec 
> driver knows the registers (and there could be the vibra driver placed 
> separately from the soc codec driver).
> In patch 3, where I modify the soc codec driver to use the new method, than I 
> remove the definitions and use the existing header file, introduced by the first 
> patch.
> All in all, after each patch the kernel can be builds, boots and works as 
> before.

Sure, though I suspect patch 3 could just be split in two happily with
an include.  I don't really mind either way.  If you are going to keep
them as one patch it'd be good to call out the move in the changelog.

> > You've also got the bias being brought up when the ASoC system comes up
> > rather than when the driver comes up.  To be honest it doesn't really
> > make any difference either way, it's just slightly different to other
> > drivers.

> I was thinking that if you built the kernel with SND_SOC_ALL_CODECS on OMAP 
> platform for some reason and you don't actually use the twl4030 as audio device 
> -> no machine driver, which would use it, than the codec part would be off.
> But yes, probably I can move the povering up to the probe function.

That's a good enough reason to leave things as they are, though really
if you're building SND_SOC_ALL_CODECs in a production system you're
being a bit strange.

> > > +MODULE_ALIAS("platform:twl4030_codec:audio");

> > Is that second colon right given...

> I'm not sure about it at all either. I did not found any other 'nested MFD' 
> drivers around, so this is just a guess
> Should it be:

>  +MODULE_ALIAS("platform:twl4030_codec_audio");

Yes.  The aliasing makes no reference to the parents of the device, it
only cares about the device name - for the purposes of module loading
and driver matching it's identical to any other platform device.
