Return-Path: <linux-kernel-owner+w=401wt.eu-S1751976AbXE2VNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbXE2VNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXE2VNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:13:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:34165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXE2VNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:13:12 -0400
To: Matt Mackall <mpm@selenic.com>
Cc: M Macnair <mmacnair@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com>
	<p73zm3nefcc.fsf@bingen.suse.de>
	<de6d2b4f0705290944i69ca8f2dudda10775ebc41c07@mail.gmail.com>
	<20070529202337.GH11166@waste.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 May 2007 00:08:22 +0200
In-Reply-To: <20070529202337.GH11166@waste.org>
Message-ID: <p73veebe10p.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:

> On Tue, May 29, 2007 at 05:44:37PM +0100, M Macnair wrote:
> > On 29 May 2007 18:58:59 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> > >"M Macnair" <mmacnair@gmail.com> writes:
> > >>
> > >> Many distros ship with an init script that saves and restores the
> > >> entropy pool on startup and shutdown.  The bit that interests me that
> > >> is called on startup is (my comments):
> > >>       if [ -f $random_seed ]; then
> > >>               cat $random_seed >/dev/urandom  # should seed the pool
> > >OA
> > >Writing doesn't actually work; to get real accounted entropy for 
> > >/dev/random
> > >you need to use a special ioctl. I ran into this problem some years ago
> > >and ended up writing http://www.muc.de/~ak/rndfeed.c
> > >
> > >-Andi
> > 
> > If this doesn't work, then it seems to me as though all the
> > debian-esque distros that use equivalents of the above script are
> > wasting their time, and the man page recommending that technique (man
> > 4 random) is also wrong.  Is that interpretation correct?
> 
> Andi is incorrect. Writing does work and everything you write is mixed

Note I wrote accounted entropy above.

> into the pool. It's just not counted as entropy credit.

This means everything using /dev/random blocks.  For me that
includes "does not work".

> This is as intended.

If the intention was to get everybody from stopping /dev/random
and moving them to /dev/urandom I guess it works well. Congratulations.

-Andi
