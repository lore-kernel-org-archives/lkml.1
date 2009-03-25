Return-Path: <linux-kernel-owner+w=401wt.eu-S1764190AbZCYRoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764190AbZCYRoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763493AbZCYRoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:44:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56914 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761264AbZCYRoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:44:02 -0400
Date: Wed, 25 Mar 2009 18:43:59 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, linux-kernel@vger.kernel.org
Subject: Re: MMC layer regression with single-block controllers
Message-ID: <20090325174359.GZ27476@kernel.dk>
References: <20090323092802.GA30122@roarinelk.homelinux.net> <20090324210138.71029c2c@mjolnir.ossman.eu> <20090325104837.GA18389@roarinelk.homelinux.net> <20090325110401.GM27476@kernel.dk> <20090325123613.06404b17@mjolnir.ossman.eu> <20090325114248.GN27476@kernel.dk> <20090325165328.251daabb@mjolnir.ossman.eu> <20090325161425.GY27476@kernel.dk> <20090325172441.26e32fe3@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325172441.26e32fe3@mjolnir.ossman.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25 2009, Pierre Ossman wrote:
> On Wed, 25 Mar 2009 17:14:25 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Mar 25 2009, Pierre Ossman wrote:
> > > 
> > > The code was there previously, but it seemed a bit redundant to have
> > > functionality like that in the block driver since we've already told
> > > the block layer about the restrictions.
> > 
> > You never saw the warnings? It's pretty clear that it does not support <
> > PAGE_CACHE_SIZE blocks. It has always been so, I don't know why the
> > subject says regression. I guess that is referring to a mmc layer
> > regression?
> > 
> 
> Yes. The MMC code did all of this magic by itself previously and
> assumed very little about the block layer.
> 
> > > The code was pretty simple. Basically it just cropped the sg list at
> > > the correct place. Couldn't that be as easily done in the block layer?
> > 
> > No, because if you do it transparently, then you have to keep partial
> > state in the bio for completions. So it makes everything a lot more
> > complex, I don't want to do that for something like this.
> > 
> 
> How is this different from the low level driver partially completing a
> request, which is how it would have to be handled otherwise?

It's a completely parallel issue. We keep extra state to handle the
partial completion bits, we would need to add even more state to handle
presenting a smaller view of the request (and the bio, it would need to
work for both) to the driver.

-- 
Jens Axboe

