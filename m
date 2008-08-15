Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbYHOTCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbYHOTCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbYHOTC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:02:28 -0400
Received: from mail.fieldses.org ([66.93.2.214]:51970 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461AbYHOTC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:02:27 -0400
Date: Fri, 15 Aug 2008 15:02:21 -0400
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] Fix allocation sizes of knfsd raparm hash
Message-ID: <20080815190221.GB26563@fieldses.org>
References: <20080815184032.3acd8032.sfr@canb.auug.org.au> <s5hr68q5rm8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hr68q5rm8.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 03:34:39PM +0200, Takashi Iwai wrote:
> The raparm was allocated in a wrong size in the commit
> 
>    ca80290ebda9009aedc4bd93ede5d397cb1853dc
>    nfsd: permit unauthenticated stat of export root
> 
> and thus it resulted in memory corruption, eventually Oopsing.
> This patch fixes the allocation size.

Whoops, my fault, now fixed; thanks!

(Out of curiosity--how did you find this?)

--b.

> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index bfa5453..30d606f 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -2093,7 +2093,7 @@ nfsd_racache_init(int cache_size)
>  
>  		raparm = &raparm_hash[i].pb_head;
>  		for (j = 0; j < nperbucket; j++) {
> -			*raparm = kzalloc(sizeof(*raparm), GFP_KERNEL);
> +			*raparm = kzalloc(sizeof(**raparm), GFP_KERNEL);
>  			if (!*raparm)
>  				goto out_nomem;
>  			raparm = &(*raparm)->p_next;
