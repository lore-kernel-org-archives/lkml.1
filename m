Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbYBGTm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbYBGTm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYBGTmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:42:18 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:36995 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYBGTmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:42:17 -0500
Date: Thu, 7 Feb 2008 20:41:20 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andreas Mohr <andi@lisas.de>
Cc: Adam Wysocki <gophi-lkml@chmurka.net>, linux-kernel@vger.kernel.org,
       giometti@enneenne.com
Subject: Re: [semi-solved] Re: [sdhci] mmc0: unrecognised SCR structure
 version 1
Message-ID: <20080207204120.5062ed2d@poseidon.drzeus.cx>
In-Reply-To: <20080206231015.GA30507@rhlx01.hs-esslingen.de>
References: <Pine.LNX.4.64.0709290538240.5571@news.chmurka.net>
	<20070929103516.3eda9bd6@poseidon.drzeus.cx>
	<20080206231015.GA30507@rhlx01.hs-esslingen.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 00:10:16 +0100
Andreas Mohr <andi@lisas.de> wrote:

> 
> My Toshiba SD-512-T card (Toshiba-specific specs are available as
> TOSHIBA_SD_Card_Specification.pdf) shows the same "SCR structure version 1"
> error message with 2.6.24 on a Motorola E680 (PXAMCI), whereas
> on 2.6.21 it did _NOT_ have it (and all SCR values there are a 1:1 match
> with the values listed in the spec .pdf!).
> 
> For me at least it turned out that while on 2.6.21, raw_scr had
> 0x00a50000 0x10011602
> on 2.6.24 raw_scr had
> 0x10011602 0x00000000
> 

Ouch. That would explain more or less any SCR related bug. :)

> IOW, the whole thing is simply shifted by one unsigned int, rendering any
> SCR interpretation fatally wrong (which, I believe, could be a
> _permanent_ error in the SD stack itself which randomly -
> depending on the exact bit content of a card's SCR dump -
> causes the SCR version check to trigger for various cards).
> Is this unsigned int shifting due to a transfer setup issue in the
> highlevel SD stack or do you think it is due to a setup issue in the
> lower-level pxamci driver in my case? If so, what setting could have
> distorted it?

I'm not seeing it on any controller here, so right now I'd guess a driver problem. No idea why though.

Are you seeing this effect on other cards?

> Weak voltage settings are not to blame, I believe (removed some configs to
> increase a bit from minimum supported voltage).
> If you don't have any specific ideas yet, any hints on how to proceed
> with tracking this down?

There's always bisecting the issue until you find the offending commit. Time consuming, but it gets the job done.

Other than that, try adding some printk() to pxamci's data transfer routines and dump the data when it is fresh.

> 
> I'd advise at least adding dumping the raw_scr values
> in the SCR version error to be able to track such error postings better
> in the future.
> 

It's definitely something to remember in future bug reports.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
