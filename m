Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbXJZNpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbXJZNpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 09:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXJZNpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 09:45:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42531 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbXJZNpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 09:45:35 -0400
Subject: Re: [interesting] smattering of possible memory ordering bugs
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, paulus@samba.org,
       benh@kernel.crashing.org, adaplas@gmail.com,
       "Morton, Andrew" <akpm@linux-foundation.org>, xfs-masters@oss.sgi.com
In-Reply-To: <200710261209.58519.nickpiggin@yahoo.com.au>
References: <200710261209.58519.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 08:45:24 -0500
Message-Id: <1193406324.6834.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Memory barriers aren't one of my strengths, but this appears correct.

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

On Fri, 2007-10-26 at 12:09 +1000, Nick Piggin wrote:
> Index: linux-2.6/fs/jfs/jfs_metapage.c
> ===================================================================
> --- linux-2.6.orig/fs/jfs/jfs_metapage.c
> +++ linux-2.6/fs/jfs/jfs_metapage.c
> @@ -39,11 +39,12 @@ static struct {
>  #endif
>  
>  #define metapage_locked(mp) test_bit(META_locked, &(mp)->flag)
> -#define trylock_metapage(mp) test_and_set_bit(META_locked,
> &(mp)->flag)
> +#define trylock_metapage(mp) test_and_set_bit_lock(META_locked,
> &(mp)->flag)
>  
>  static inline void unlock_metapage(struct metapage *mp)
>  {
> -       clear_bit(META_locked, &mp->flag);
> +       clear_bit_unlock(META_locked, &mp->flag);
> +       smp_mb__after_clear_bit();
>         wake_up(&mp->wait);
>  }
>   

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

