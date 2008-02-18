Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYBROOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYBROOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYBROON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:14:13 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38151 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbYBROOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:14:12 -0500
Date: Mon, 18 Feb 2008 16:13:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, Roel Kluin <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>, cbe-oss-dev@ozlabs.org,
       linuxppc-dev@ozlabs.org, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080218141340.GB667@cs181133002.pp.htv.fi>
References: <47B70A61.9030306@tiscali.nl> <20080216092552.325e5726@laptopd505.fenrus.org> <20080216173315.GU8953@1wt.eu> <20080216094226.1e8eede1@laptopd505.fenrus.org> <47B72BFE.9060302@am.sony.com> <20080216103927.2a02352b@laptopd505.fenrus.org> <1203249003.6718.24.camel@concordia> <20080218135609.GD21080@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0802181500410.13406@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802181500410.13406@vixen.sonytel.be>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 03:01:35PM +0100, Geert Uytterhoeven wrote:
> On Mon, 18 Feb 2008, Adrian Bunk wrote:
> > 
> > This means it generates faster code with a current gcc for your platform.
> > 
> > But a future gcc might e.g. replace the whole loop with a division
> > (gcc SVN head (that will soon become gcc 4.3) already does 
> > transformations like replacing loops with divisions [1]).
> 
> Hence shouldn't we ask the gcc people what's the purpose of __builtin_expect(),
> if it doesn't live up to its promise?

That's a different issue.

My point here is that we do not know how the latest gcc available in the 
year 2010 might transform this code, and how a likely/unlikely placed 
there might influence gcc's optimizations then.

If this is in hotpath code with a measurable speedup when using 
likely/unlikely with a current gcc then it's worth it.

But otherwise it brings no real advantage today and the longterm effects 
are not predictable.

> With kind regards,
> 
> Geert Uytterhoeven

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

