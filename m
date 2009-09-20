Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZITSE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZITSE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZITSE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:04:26 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47896 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZITSEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=crsKZEaweIa95GE+2nuu6A64oky4QzY6+gCOCf6siDEGYC4oSASgJ09lBKGhfzSdfr
         uoQL5B4lhI1taV0ffaEnWOMJMLfzXOzKGBZ6RZ7Ms4ZI05k90euasRDn83I4sKwT0OeC
         vs6ep6QUod+2tccIECkJjHiS/LZFTUUARGlg8=
Date: Sun, 20 Sep 2009 22:04:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, hugh.dickins@tiscali.co.uk
Subject: Re: shmem_fill_super(): WARNING: kmemcheck: Caught 32-bit read
	from uninitialized memory
Message-ID: <20090920180427.GA32176@lenovo>
References: <20090915080953.GA24958@elte.hu> <20090920072210.GA23787@elte.hu> <19f34abd0909201035t3157948amee532a3a5e96dbab@mail.gmail.com> <alpine.DEB.2.00.0909202046460.7394@melkki.cs.helsinki.fi> <20090920175803.GB23736@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920175803.GB23736@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Sep 20, 2009 at 07:58:03PM +0200]
...
| 
| > [    0.408000] initcall init_mmap_min_addr+0x0/0x10 returned 0 after 0 usecs
| >
| > Reported-by: Ingo Molnar <mingo@elte.hu>
| > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
| > ---
| >  mm/shmem.c |    5 +----
| >  1 files changed, 1 insertions(+), 4 deletions(-)
| >
| > diff --git a/mm/shmem.c b/mm/shmem.c
| > index d713239..a8f54f3 100644
| > --- a/mm/shmem.c
| > +++ b/mm/shmem.c
| > @@ -2307,17 +2307,14 @@ static int shmem_fill_super(struct super_block *sb,
| >  	int err = -ENOMEM;
| >
| >  	/* Round up to L1_CACHE_BYTES to resist false sharing */
| > -	sbinfo = kmalloc(max((int)sizeof(struct shmem_sb_info),
| > +	sbinfo = kzalloc(max((int)sizeof(struct shmem_sb_info),
| >  				L1_CACHE_BYTES), GFP_KERNEL);
| >  	if (!sbinfo)
| >  		return -ENOMEM;
| >
| > -	sbinfo->max_blocks = 0;
| > -	sbinfo->max_inodes = 0;
| >  	sbinfo->mode = S_IRWXUGO | S_ISVTX;
| >  	sbinfo->uid = current_fsuid();
| >  	sbinfo->gid = current_fsgid();
| > -	sbinfo->mpol = NULL;
| >  	sb->s_fs_info = sbinfo;
| 
| That looks like a step forward even without kmemcheck considered, right?
| 
| 	Ingo

Yeah, and we save a few cpu cycles as well :)

	-- Cyrill
