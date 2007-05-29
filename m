Return-Path: <linux-kernel-owner+w=401wt.eu-S1764719AbXE2UZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764719AbXE2UZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbXE2UZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:25:44 -0400
Received: from waste.org ([66.93.16.53]:46077 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbXE2UZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:25:43 -0400
Date: Tue, 29 May 2007 15:23:37 -0500
From: Matt Mackall <mpm@selenic.com>
To: M Macnair <mmacnair@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
Message-ID: <20070529202337.GH11166@waste.org>
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com> <p73zm3nefcc.fsf@bingen.suse.de> <de6d2b4f0705290944i69ca8f2dudda10775ebc41c07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <de6d2b4f0705290944i69ca8f2dudda10775ebc41c07@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 05:44:37PM +0100, M Macnair wrote:
> On 29 May 2007 18:58:59 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> >"M Macnair" <mmacnair@gmail.com> writes:
> >>
> >> Many distros ship with an init script that saves and restores the
> >> entropy pool on startup and shutdown.  The bit that interests me that
> >> is called on startup is (my comments):
> >>       if [ -f $random_seed ]; then
> >>               cat $random_seed >/dev/urandom  # should seed the pool
> >OA
> >Writing doesn't actually work; to get real accounted entropy for 
> >/dev/random
> >you need to use a special ioctl. I ran into this problem some years ago
> >and ended up writing http://www.muc.de/~ak/rndfeed.c
> >
> >-Andi
> 
> If this doesn't work, then it seems to me as though all the
> debian-esque distros that use equivalents of the above script are
> wasting their time, and the man page recommending that technique (man
> 4 random) is also wrong.  Is that interpretation correct?

Andi is incorrect. Writing does work and everything you write is mixed
into the pool. It's just not counted as entropy credit. This is as
intended.

-- 
Mathematics is the supreme nostalgia of our time.
