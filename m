Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZBWQbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZBWQbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZBWQau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:30:50 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:2736 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZBWQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:30:49 -0500
Date: Mon, 23 Feb 2009 11:30:32 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090223163032.GA3450@hash.localnet>
References: <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <40f31dec0902230803qcbd4c20kc66a50e6e2e8eef2@mail.gmail.com> <40f31dec0902230815x6b43fa50h41edfeead96822a3@mail.gmail.com> <20090223162103.GA3383@hash.localnet> <40f31dec0902230827j5c0f9f20je02c7fb02709f71e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f31dec0902230827j5c0f9f20je02c7fb02709f71e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 06:27:35PM +0200, Nick Kossifidis wrote:
> 2009/2/23 Bob Copeland <me@bobcopeland.com>:
> > On Mon, Feb 23, 2009 at 06:15:51PM +0200, Nick Kossifidis wrote:
> >> Typo alert...
> >> rs->rs_more = !!(rx_status->rx_status_0 & AR5K_5212_RX_DESC_STATUS0_MORE);
> >
> > I'm slow... what's wrong with it?
> >
> 
> "!!"
> 
> it should be just
> 
> rs->rs_more = (rx_status->rx_status_0 & AR5K_5212_RX_DESC_STATUS0_MORE);

No, that's intentional.  That was actually a bug we had at some point 
(rs_more is a u8 so the bitwise AND overflowed).  The "!!" makes it zero 
or one so it fits.

-- 
Bob Copeland %% www.bobcopeland.com

