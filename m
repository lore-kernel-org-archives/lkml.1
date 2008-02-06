Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbYBFXOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbYBFXOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbYBFXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:10:21 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45433 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764051AbYBFXKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:10:18 -0500
Date: Thu, 7 Feb 2008 00:10:16 +0100
From: Andreas Mohr <andi@lisas.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Adam Wysocki <gophi-lkml@chmurka.net>, linux-kernel@vger.kernel.org,
       giometti@enneenne.com
Subject: [semi-solved] Re: [sdhci] mmc0: unrecognised SCR structure version
	1
Message-ID: <20080206231015.GA30507@rhlx01.hs-esslingen.de>
References: <Pine.LNX.4.64.0709290538240.5571@news.chmurka.net> <20070929103516.3eda9bd6@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929103516.3eda9bd6@poseidon.drzeus.cx>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Sep 29, 2007 at 10:35:16AM +0200, Pierre Ossman wrote:
> On Sat, 29 Sep 2007 05:42:37 +0200 (CEST)
> Adam Wysocki <gophi-lkml@chmurka.net> wrote:
> 
> > [CCd to possibly interested Pierre Ossman and Rodolfo Giometti]
> > 
> > Hi there,
> > 
> > First, sorry for my poor english - I am not a native.
> > 
> > I know there have been a thread about this problem few months ago,
> > but as far as I see it did not led to any results: 
> > http://groups.google.com/group/linux.kernel/browse_thread/thread/19116cafe8a20b5/4a28c3b15bb999df
> > 
> > I have the same problem, as described there, with Kingston 2GB SD
> > card. My card reader is embedded into Fujitsu-Siemens AMILO Pro V3505
> > notebook and Linux sees it as:
> > 
> 
> If it's just this card, then I would have to conclude that it is indeed
> broken. You'd have to return it to the store and get a new one.

My Toshiba SD-512-T card (Toshiba-specific specs are available as
TOSHIBA_SD_Card_Specification.pdf) shows the same "SCR structure version 1"
error message with 2.6.24 on a Motorola E680 (PXAMCI), whereas
on 2.6.21 it did _NOT_ have it (and all SCR values there are a 1:1 match
with the values listed in the spec .pdf!).

For me at least it turned out that while on 2.6.21, raw_scr had
0x00a50000 0x10011602
on 2.6.24 raw_scr had
0x10011602 0x00000000

IOW, the whole thing is simply shifted by one unsigned int, rendering any
SCR interpretation fatally wrong (which, I believe, could be a
_permanent_ error in the SD stack itself which randomly -
depending on the exact bit content of a card's SCR dump -
causes the SCR version check to trigger for various cards).
Is this unsigned int shifting due to a transfer setup issue in the
highlevel SD stack or do you think it is due to a setup issue in the
lower-level pxamci driver in my case? If so, what setting could have
distorted it?
Weak voltage settings are not to blame, I believe (removed some configs to
increase a bit from minimum supported voltage).
If you don't have any specific ideas yet, any hints on how to proceed
with tracking this down?

I'd advise at least adding dumping the raw_scr values
in the SCR version error to be able to track such error postings better
in the future.

I'm now giving up on tracking this down myself (I'll just bail the check for
now to have it boot properly) since originally I had more productive things
in mind ;)
(note that disabling the check on 2.6.24 makes the card boot ok
up to a full mobile desktop)

Thanks,

Andreas Mohr
