Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYICKjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYICKjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYICKi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:38:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2661 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYICKi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:38:57 -0400
Date: Wed, 3 Sep 2008 11:38:52 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: Bryan Wu <cooloney@kernel.org>, perex@perex.cz, lrg@kernel.org,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC framework
Message-ID: <20080903103850.GA20438@sirena.org.uk>
Mail-Followup-To: "Cai, Cliff" <Cliff.Cai@analog.com>,
	Bryan Wu <cooloney@kernel.org>, perex@perex.cz, lrg@kernel.org,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-2-git-send-email-cooloney@kernel.org> <20080827134830.GC10834@sirena.org.uk> <0F1B54C89D5F954D8535DB252AF412FA02A26AC0@chinexm1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA02A26AC0@chinexm1.ad.analog.com>
X-Cookie: Ducks?  What ducks??
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 12:09:49PM +0800, Cai, Cliff wrote:

Cliff, please fix your mail client configuration - the formatting of
your reply makes little (if any) distinction between the text of my
original mail which makes your message difficult to read.

> -----Original Message-----
> From: Mark Brown [mailto:broonie@sirena.org.uk] 
> Sent: Wednesday, August 27, 2008 9:49 PM
> To: Bryan Wu
> Cc: perex@perex.cz; lrg@kernel.org; alsa-devel@alsa-project.org;
> linux-kernel@vger.kernel.org; Cliff Cai
> Subject: Re: [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC framework

> On Wed, Aug 27, 2008 at 05:39:25PM +0800, Bryan Wu wrote:
> > From: Cliff Cai <cliff.cai@analog.com>

> >Again, odd blank lines and presumably there needs to be something to
> undo things on error?

> t's not necessary to do anything else on error, these functions only set
> registers.

And none of these settings will leave things so that the port looks busy
or anything like that?

> TX and RX Clocks are also not independent,currently,in order to
> implement full duplex,we have to enable both RX and TX side even if
> there is only a steam is opened,
> And make the other side running on a dummy buffer,so all registers
> cann't be configured any more. when the second stream is opened we just
> switch the DMA form dummy buffer to the normal data buffer.

Right, in that case your driver should use constraints to stop
applications trying to configure the capture and playback sides
differently.

> >I'm also not seeing the code that configures the sample rate anywhere -
> but then it looks like the driver only support slave mode ATM?  That's
> what the machine driver is
>  >using.  There should still be a set_fmt() to document what's supported
> if nothing else.

> Yes ,the codec runs in master mode and provides bit clock..Do you mean
> just implement a dummy set_fmt() with comments for CPU DAI,

It shouldn't just be a dummy - it should reject DAI formats other than
CBS_CFM if that is the only configuration that's supported.

> Refer to my description above,it's not possible to configure anything
> for CPU DAI after a stream is opened ,that why we have to configure CPU
> DAI before any stream is opened.

This is normal (and generally trying would result in audio artifacts if
you try), but normally there is at least some configuration that can be
done before the stream actually starts running.
