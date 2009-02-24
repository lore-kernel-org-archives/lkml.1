Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbZBXN6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbZBXN6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZBXN60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:58:26 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3262 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbZBXN60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:58:26 -0500
Date: Tue, 24 Feb 2009 08:58:17 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090224135817.GB6019@hash.localnet>
References: <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 01:08:03AM +0200, Nick Kossifidis wrote:
> He does an extra check...
> 
> 	/*
> 	 * Given the use of a self-linked tail be very sure that the hw is
> 	 * done with this descriptor; the hw may have done this descriptor
> 	 * once and picked it up again...make sure the hw has moved on.
> 	 */
> 	if ((ands->ds_rxstatus1&AR_Done) == 0 && OS_REG_READ(ah, AR_RXDP) == pa)
> 		return HAL_EINPROGRESS;

Sounds like we definitely need that.  If the hw uses up all the dma buffers
in one go, there's a good chance we can send the skb to mac80211 while
the hardware is still using it.  I guess an easy way to test would be to
set the max rx buffers to 3 or so and watch the fireworks.

-- 
Bob Copeland %% www.bobcopeland.com

