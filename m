Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbXE2VrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbXE2VrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXE2Vq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:46:59 -0400
Received: from waste.org ([66.93.16.53]:37163 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbXE2Vq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:46:58 -0400
Date: Tue, 29 May 2007 16:44:46 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: M Macnair <mmacnair@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
Message-ID: <20070529214446.GB11115@waste.org>
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com> <p73zm3nefcc.fsf@bingen.suse.de> <de6d2b4f0705290944i69ca8f2dudda10775ebc41c07@mail.gmail.com> <20070529202337.GH11166@waste.org> <p73veebe10p.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <p73veebe10p.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 12:08:22AM +0200, Andi Kleen wrote:
> Matt Mackall <mpm@selenic.com> writes:
> 
> > On Tue, May 29, 2007 at 05:44:37PM +0100, M Macnair wrote:
> > > On 29 May 2007 18:58:59 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> > > >"M Macnair" <mmacnair@gmail.com> writes:
> > > >>
> > > >> Many distros ship with an init script that saves and restores the
> > > >> entropy pool on startup and shutdown.  The bit that interests me that
> > > >> is called on startup is (my comments):
> > > >>       if [ -f $random_seed ]; then
> > > >>               cat $random_seed >/dev/urandom  # should seed the pool
> > > >OA
> > > >Writing doesn't actually work; to get real accounted entropy for 
> > > >/dev/random
> > > >you need to use a special ioctl. I ran into this problem some years ago
> > > >and ended up writing http://www.muc.de/~ak/rndfeed.c
> > > >
> > > >-Andi
> > > 
> > > If this doesn't work, then it seems to me as though all the
> > > debian-esque distros that use equivalents of the above script are
> > > wasting their time, and the man page recommending that technique (man
> > > 4 random) is also wrong.  Is that interpretation correct?
> > 
> > Andi is incorrect. Writing does work and everything you write is mixed
> 
> Note I wrote accounted entropy above.
> 
> > into the pool. It's just not counted as entropy credit.
> 
> This means everything using /dev/random blocks.  For me that
> includes "does not work".
> 
> > This is as intended.
> 
> If the intention was to get everybody from stopping /dev/random
> and moving them to /dev/urandom I guess it works well. Congratulations.

The intention is to be secure. It's well-known that goal is often in
conflict with being user-friendly. Pretending we have entropy that we
don't is user-friendly but not secure.

And indeed, there's no reason to think there was any entropy in the
pool when we dumped the seed data from /dev/urandom to disk at
shutdown, so there's no reason we should claim there was any there
when we start up. Especially as someone may have looked at that file
in the interim.

Further, congratulations aren't due to me. Linux /dev/random has
gotten this right since day one.

-- 
Mathematics is the supreme nostalgia of our time.
