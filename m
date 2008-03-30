Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbYC3WKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbYC3WKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYC3WKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:10:03 -0400
Received: from gherkin.frus.com ([192.158.254.49]:47541 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYC3WKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:10:01 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47DEEA09.9000108@keyaccess.nl> "from Rene Herman at Mar 17, 2008
 11:00:41 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Sun, 30 Mar 2008 17:09:56 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Michael Cree <mcree@orcon.net.nz>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080330220956.1E9C6DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Okay, thought I'd stare at this thing a bit -- there's no specific 1888 
> documentation available it seems but I did notice something in the 1878 
> datasheet which might mean something. The docs says that bits 0-1 are don't 
> care for DMA but don't for IRQ, so could it possibly be as simple as the 
> attached?
> 
> 1878 sheet doesn't document register 0x7f, it seems...
> 
> Assuming it's not just this, this thing is going to require quite a bit of 
> trial and error and without the hardware this will be troublesome. I expect 
> this is not it, since the arch init code also doesn't care about bit 0 when 
> setting that same register for IRQ 5.
> 
> If this is not it -- I'd try s/0x50/0x10/ in that line, even completely 
> commenting out the IRQ setting line (with the arch code built in) and just 
> generally frolic around 'till something blows up...
>
> (es18xx_trial_and_error)

As distributed, no change: still not seeing any activity on IRQ 5.  I'll
play around with it some over the next day or so.

Observed: the alsa "snd-sb8" driver works fine.  Question: how does IRQ
setup differ between the sb8 and the es18xx drivers?  If I can find some
time, I'll try to figure that out...

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
