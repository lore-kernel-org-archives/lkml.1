Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYIDEAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYIDEAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYIDEAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:00:22 -0400
Received: from bay0-omc2-s38.bay0.hotmail.com ([65.54.246.174]:22606 "EHLO
	bay0-omc2-s38.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbYIDEAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:00:21 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 00:00:21 EDT
Message-ID: <BAY110-W23D3CD96F1CD07678A9100C9590@phx.gbl>
X-Originating-IP: [137.71.23.54]
From: Cliff Cai <xcahua@hotmail.com>
To: Mark Brown <broonie@sirena.org.uk>
CC: <linux-kernel@vger.kernel.org>, Bryan Wu <cooloney@kernel.org>,
       <alsa-devel@alsa-project.org>, <lrg@kernel.org>
Subject: RE: [alsa-devel] [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC
	framework
Date: Thu, 4 Sep 2008 03:54:10 +0000
Importance: Normal
In-Reply-To: <20080903103850.GA20438@sirena.org.uk>
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
	<1219829968-6431-2-git-send-email-cooloney@kernel.org>
 	<20080827134830.GC10834@sirena.org.uk>
 	<0F1B54C89D5F954D8535DB252AF412FA02A26AC0@chinexm1.ad.analog.com> 
 <20080903103850.GA20438@sirena.org.uk>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Sep 2008 03:54:10.0141 (UTC) FILETIME=[E30860D0:01C90E41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





> Date: Wed, 3 Sep 2008 11:38:52 +0100
> From: broonie@sirena.org.uk
> To: Cliff.Cai@analog.com
> CC: linux-kernel@vger.kernel.org; cooloney@kernel.org; alsa-devel@alsa-project.org; lrg@kernel.org
> Subject: Re: [alsa-devel] [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC framework
>
> On Wed, Sep 03, 2008 at 12:09:49PM +0800, Cai, Cliff wrote:
>
> Cliff, please fix your mail client configuration - the formatting of
> your reply makes little (if any) distinction between the text of my
> original mail which makes your message difficult to read.
>
>> -----Original Message-----
>> From: Mark Brown [mailto:broonie@sirena.org.uk]
>> Sent: Wednesday, August 27, 2008 9:49 PM
>> To: Bryan Wu
>> Cc: perex@perex.cz; lrg@kernel.org; alsa-devel@alsa-project.org;
>> linux-kernel@vger.kernel.org; Cliff Cai
>> Subject: Re: [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC framework
>
>> On Wed, Aug 27, 2008 at 05:39:25PM +0800, Bryan Wu wrote:
>>> From: Cliff Cai 
>
>>>Again, odd blank lines and presumably there needs to be something to
>> undo things on error?
>
>> t's not necessary to do anything else on error, these functions only set
>> registers.
>
> And none of these settings will leave things so that the port looks busy
> or anything like that?


No,they are called just to configure somthing but won't start it,it only fails when the port is busy.


>
>> TX and RX Clocks are also not independent,currently,in order to
>> implement full duplex,we have to enable both RX and TX side even if
>> there is only a steam is opened,
>> And make the other side running on a dummy buffer,so all registers
>> cann't be configured any more. when the second stream is opened we just
>> switch the DMA form dummy buffer to the normal data buffer.
>
> Right, in that case your driver should use constraints to stop
> applications trying to configure the capture and playback sides
> differently.
>
>>>I'm also not seeing the code that configures the sample rate anywhere -
>> but then it looks like the driver only support slave mode ATM? That's
>> what the machine driver is
>>>using. There should still be a set_fmt() to document what's supported
>> if nothing else.
>
>> Yes ,the codec runs in master mode and provides bit clock..Do you mean
>> just implement a dummy set_fmt() with comments for CPU DAI,
>
> It shouldn't just be a dummy - it should reject DAI formats other than
> CBS_CFM if that is the only configuration that's supported.
>
>> Refer to my description above,it's not possible to configure anything
>> for CPU DAI after a stream is opened ,that why we have to configure CPU
>> DAI before any stream is opened.
>
> This is normal (and generally trying would result in audio artifacts if
> you try), but normally there is at least some configuration that can be
> done before the stream actually starts running.
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel

_________________________________________________________________
一边聊天一边快速搜索，并把结果共享给好友，立刻试试！
http://im.live.cn/Share/18.htm
