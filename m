Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXHQPtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXHQPtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbXHQPtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:49:00 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46371 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbXHQPs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:48:59 -0400
Date: Fri, 17 Aug 2007 11:48:04 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
Subject: Re: [PATCH 02/23] lib: percpu_counter_add
Message-ID: <20070817154804.GC24323@filer.fsl.cs.sunysb.edu>
References: <20070816074525.065850000@chello.nl> <20070816074624.963595000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816074624.963595000@chello.nl>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:45:27AM +0200, Peter Zijlstra wrote:
...
> Index: linux-2.6/fs/ext2/balloc.c
> ===================================================================
> --- linux-2.6.orig/fs/ext2/balloc.c
> +++ linux-2.6/fs/ext2/balloc.c
> @@ -163,7 +163,7 @@ static int reserve_blocks(struct super_b
>  			return 0;
>  	}
>  
> -	percpu_counter_mod(&sbi->s_freeblocks_counter, -count);
> +	percpu_counter_add(&sbi->s_freeblocks_counter, -count);

Out of curiosity, I noticed similar thing being done in the vm code, what is
preferred:

	foobar_add(&counter, -num);

or

	foobar_sub(&counter, num);

?

Josef 'Jeff' Sipek.

-- 
Research, n.:
  Consider Columbus:
    He didn't know where he was going.
    When he got there he didn't know where he was.
    When he got back he didn't know where he had been.
    And he did it all on someone else's money.
