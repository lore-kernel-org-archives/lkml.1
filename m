Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbZBZVFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbZBZVFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZBZVFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:05:18 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3364 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZBZVFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:05:17 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Date: Thu, 26 Feb 2009 16:05:06 -0500
Message-Id: <20090226205921.M20262@bobcopeland.com>
In-Reply-To: <49A70134.4070700@gmail.com>
References: <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226010625.GA10577@hash.localnet> <49A70134.4070700@gmail.com>
X-Mailer: OpenWebMail 2.53 
X-OriginatingIP: 149.101.1.121 (bob)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 21:53:08 +0100, Jiri Slaby wrote
> On 26.2.2009 02:06, Bob Copeland wrote:
> > --- a/drivers/net/wireless/ath5k/base.c
> > +++ b/drivers/net/wireless/ath5k/base.c
> > @@ -1140,12 +1140,14 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct
ath5k_buf *bf)
> >   	struct ath5k_hw *ah = sc->ah;
> >   	struct sk_buff *skb = bf->skb;
> >   	struct ath5k_desc *ds;
> > +	dma_addr_t dma_addr;
> >
> >   	if (!skb) {
> > -		skb = ath5k_rx_skb_alloc(sc,&bf->skbaddr);
> > +		skb = ath5k_rx_skb_alloc(sc,&dma_addr);
> >   		if (!skb)
> >   			return -ENOMEM;
> >   		bf->skb = skb;
> > +		bf->skbaddr = dma_addr;
> 
> Hmm, rather than the caller, ath5k_rx_skb_alloc is wrong here in my 
> eyes. It shouldn't touch the second parameter unless it knows it won't 
> fail anymore.

Sure, the temporary could go there instead.  It's a consequence of my
making ath5k_rx_skb_alloc() as much as possible a straight code move
from the original, which IIRC would also clobber bf->skbaddr on the
error path.

-- 
Bob Copeland %% www.bobcopeland.com


