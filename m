Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbZKOHQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbZKOHQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZKOHQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:16:28 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:51364 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZKOHQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:16:26 -0500
Date: Sun, 15 Nov 2009 08:16:31 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] hpfs: Use hweight32
In-Reply-To: <20091113153255.9726be89.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0911150811520.8118@artax.karlin.mff.cuni.cz>
References: <1258096028-13426-1-git-send-email-akinobu.mita@gmail.com>
 <20091113153255.9726be89.akpm@linux-foundation.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Nov 2009, Andrew Morton wrote:

> On Fri, 13 Nov 2009 16:07:08 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 
> > Use hweight32 instead of counting for each bit
> > 
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >  fs/hpfs/super.c |    7 ++-----
> >  1 files changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
> > index f2feaa0..cf6fe4a 100644
> > --- a/fs/hpfs/super.c
> > +++ b/fs/hpfs/super.c
> > @@ -119,11 +119,8 @@ unsigned hpfs_count_one_bitmap(struct super_block *s, secno secno)
> >  	unsigned i, count;
> >  	if (!(bits = hpfs_map_4sectors(s, secno, &qbh, 4))) return 0;
> >  	count = 0;
> > -	for (i = 0; i < 2048 / sizeof(unsigned); i++) {
> > -		unsigned b; 
> > -		if (!bits[i]) continue;
> > -		for (b = bits[i]; b; b>>=1) count += b & 1;
> > -	}
> > +	for (i = 0; i < 2048 / sizeof(unsigned); i++)
> > +		count += hweight32(bits[i]);
> >  	hpfs_brelse4(&qbh);
> >  	return count;
> 
> Could actualy use bitmap_weight() here.
> 
> It's a bit naughty, because bitmap_weight() operates on long*'s, but it
> will work OK.
> 
> Shrug.

... and add support for popcnt, so that it's optimized on AMD CPUs.

Mikulas
