Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbYHDVzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbYHDVzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYHDVsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:48:20 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:18545 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754019AbYHDVsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:48:19 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=Cqzkcde1pHFAUeeOa2AA:9 a=be6kOz2DemxUHkcOEJiUC4fh0RgA:4 a=ZCnnSLshPu8A:10 a=lN1hEWcJ4VIA:10
Message-ID: <48977921.5040403@shaw.ca>
Date: Mon, 04 Aug 2008 15:48:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no> <fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no> <fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no> <48976168.3020804@shaw.ca> <20080804205508.20a3f917@lxorguk.ukuu.org.uk> <48977200.3050307@shaw.ca> <20080804220619.76b94ceb@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804220619.76b94ceb@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> You mentioned in the thread for Willy's patch that "some
>> controllers have quirky rules for 32bit xfers" - any details anywhere?
> 
> There are two main ones
> 
> - Some controllers only support 32bit I/O for a multiple of 32bit values
> [sometimes 'unless the fifo is disabled']. I'd have to go back over the
> docs but I think the AMD may be one of those

The AMD-766 doc I have says that when the Secondary Posted Write Buffer 
or Primary Posted Write Buffer are enabled, only 32-bit writes are 
allowed to the data port. It doesn't say anything about a restriction 
with the read prefetch buffer though.

I guess it depends if any other controllers could potentially have this 
restriction. I suspect non-multiple-of-32-bit transfers are rare enough 
we could just fall back to 16-bit IO always for them, but maybe not.

> - Some controllers (VLB generally) require a magic sequence before the
> transfer. You'll see that in the pata_legacy bits.
> 
> Alan
> 
