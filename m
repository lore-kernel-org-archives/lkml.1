Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYC1XTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYC1XTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYC1XSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:18:54 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:34458 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbYC1XSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:18:53 -0400
Date: Fri, 28 Mar 2008 19:18:33 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/7] omfs: define filesystem structures
Message-ID: <20080328231833.GA16515@hash.localnet>
References: <1206578760-9050-1-git-send-email-me@bobcopeland.com> <20080328201940.GA3974@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328201940.GA3974@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 09:19:40PM +0100, Pavel Machek wrote:
> On Wed 2008-03-26 20:45:54, Bob Copeland wrote:
> > OMFS is a proprietary filesystem created for the ReplayTV and
> > also used by the Rio Karma.  It uses hash tables with unordered,
> > unbounded lists in each bucket for directories, extents for
> 
> Why did they create such beast?

Heh, I wish I knew.  Good old NIH.  There were so many "interesting"
decisions here, like requiring seeks all over the place for dir
traversal, picking a hash function that has collisions in almost every
bucket even when the table is half empty, wasting large amounts of space
by not even using 3/4s of certain blocks -- it's hard to pick a favorite.

Oh, on ReplayTV 4/5xxx they also byte-swapped the block layer such that
every 4 bytes were written backwards (even data).  So a be64 would
be written out as 'le32_high le32_low'.  This patch doesn't support that 
brain damage, but I did cook up a bswap dm target to test with one of 
those disk images.

> > +struct omfs_header {
> > +	__be64 h_self;
> > +	__be32 h_body_size;
> > +	__be16 h_crc;
> > +	char h_fill1[2];
> > +	u8 h_version;
> > +	char h_type;
> > +	u8 h_magic;
> > +	u8 h_check_xor;
> > +	__be32 h_fill2;
> > +};
> 
> attribute packed or something? Some strange machine (alpha?) may
> decide to align u8s at 32bit boundaries...

Thanks, I guess this applies for all the on disk structs.

-- 
Bob Copeland %% www.bobcopeland.com 

