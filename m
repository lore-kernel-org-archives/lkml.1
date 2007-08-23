Return-Path: <linux-kernel-owner+w=401wt.eu-S1763790AbXHWOlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763790AbXHWOlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761763AbXHWOlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:41:16 -0400
Received: from fydelkass.inl.fr ([195.101.59.116]:46370 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759028AbXHWOlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:41:16 -0400
Date: Thu, 23 Aug 2007 16:41:14 +0200
From: Pierre Chifflier <p.chifflier@inl.fr>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pierre Chifflier <p.chifflier@inl.fr>, linux-kernel@vger.kernel.org
Subject: Re: intel_rng: FWH not detected (and no entropy)
Message-ID: <20070823144114.GE22638@piche.inl.fr>
References: <20070823090414.GD22638@piche.inl.fr> <20070823125304.GA22901@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823125304.GA22901@khazad-dum.debian.net>
Organization: INL
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 09:53:04AM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 23 Aug 2007, Pierre Chifflier wrote:
> > I'm not sure the mhat a hardware RNG is present, so I want to check.
> 
> Open the mobo, and locate all FLASH chips.  If one of them is a 82802AB or
> 82802AC, then you *MIGHT* have an Intel FWH with a HRNG (some of the FWHs
> have their RNGs disabled, and since Intel stopped guaranteeing the RNG is
> there, they would install one such FWH in their boards just the same).  If
> none are a 82802AB or 82802AC, you don't have an Intel FWH with a HRNG.
> 
> Even if you had an Intel board that is known to sometimes have an Intel FWH
> with an RNG, like the D875PBZ, that wouldn't mean much.  They could have
> used an non-Intel equivalent part for that production run, for unknown
> reasons.  You really have to check.

Well, I've seen nothing more than the 82801DB (which was listed in
lspci). So maybe there is no HRNG :(

This leaves the main problem, which is the lack of entropy. Does anyone
have an idea on how to solve this problem ?
It appeared with recent kernels. For ex, 2.6.8 had an entropy pool
always > 3000, while 2.6.18 and other recent kernels show ~ 150.

# sysctl kernel.random.poolsize
kernel.random.poolsize = 4096
# sysctl kernel.random.entropy_avail
kernel.random.entropy_avail = 196

This is really annoying, since the box should also use SSL/TLS
operations, and it will be real slow ..

Regards,
Pierre
