Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbZAHJY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbZAHJY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbZAHJYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:24:12 -0500
Received: from cs20.apochromatic.org ([204.152.189.161]:54944 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZAHJYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:24:09 -0500
Date: Thu, 8 Jan 2009 09:24:07 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang M?es <wolfgang.mues@auerswald.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver
Message-ID: <20090108092407.GA6108@console-pimps.org>
References: <20090106161006.GA28020@console-pimps.org> <200901080922.08773.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901080922.08773.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 09:22:08AM +0100, Wolfgang M?es wrote:
> Matt,
> 
> Am Dienstag, 6. Januar 2009 schrieb Matt Fleming:
> > Which cards are you having issues with?
> 
> This was a noname 4 GByte SDHC card. If you write a continious stream of data 
> at max. speed, the card generates a BUSY signal every 10 seconds for nearly a 
> whole second.
> 

Ouch :-/

> > Modifying the code to no longer abide by the standard doesn't seem like a
> > win to me.
> 
> I strongly disagree with you.
> 
> While each and every SD card should conform to the standard, a driver for a 
> host controller should be as forgiving as possible. If the driver cannot cope 
> with cards sold today, the user has a bad experience.
> 
> I code drivers for people and not for standards.
> 
> Remember, this is only a timeout. Lengthen the timeout will have no 
> consequences for cards which behave.

My concern is that completely broken cards may be able to get away with more
if the timeout is extended. There is clearly a tradeoff here between
supporting non-conforming cards and easily detecting broken cards.

Someone suggested to me off list that having a configuration option to
enable/disable the longer timeout is a good compromise, and I agree.
