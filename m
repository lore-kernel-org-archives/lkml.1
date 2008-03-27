Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbYC0MlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYC0MlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760078AbYC0MjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:39:08 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:41226 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760596AbYC0MjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:39:06 -0400
Date: Thu, 27 Mar 2008 08:38:55 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/7] omfs: add inode routines
Message-ID: <20080327123855.GC10265@hash.localnet>
References: <1206578760-9050-2-git-send-email-me@bobcopeland.com> <87k5jon17l.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5jon17l.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 07:13:50AM +0100, Andi Kleen wrote:
> Bob Copeland <me@bobcopeland.com> writes:
> > +
> > +	bitmap_size = (sbi->s_num_blocks + 7) / 8;
> > +	array_size = (bitmap_size + sb->s_blocksize - 1) / sb->s_blocksize;
> > +
> > +	sbi->s_imap_size = array_size;
> > +	sbi->s_imap = kzalloc(array_size * sizeof(unsigned long), GFP_KERNEL);
> 
> 
> If the array can be really 300k you should probably have a vmalloc fallback
> here.

bitmap_size will be 300k (20G / 8192 / 8), but array_size adds another
level of indirection so s_imap will be 300k/8192 segments, each of size 
8192.  Hmm, I guess that should be 'sizeof(unsigned long *)' above.

One might wonder why we keep it in memory anyway since we can read the
bitmap blocks on demand.  The reason is that once the tree walk is added
for ReplayTV then it would use this same i_map.  However, I've yet to 
hear from interested RTV folks so it is currently read-only and there is 
no tree walk for the bitmap.

-- 
Bob Copeland %% www.bobcopeland.com 

