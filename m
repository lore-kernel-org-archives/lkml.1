Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZDGNkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZDGNkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZDGNkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:40:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZDGNkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:40:36 -0400
Date: Tue, 7 Apr 2009 15:40:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090407134017.GA20556@elte.hu>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239070789-13354-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +/*
> + * Utility function to force a BUG if it is called without the superblock
> + * write lock held.  caller is the string printed just before calling BUG()
> + */
> +void reiserfs_check_lock_depth(struct super_block *sb, char *caller)
> +{
> +	struct reiserfs_sb_info *sb_i = REISERFS_SB(sb);
> +
> +	if (sb_i->lock_depth < 0)
> +		reiserfs_panic(sb, "%s called without kernel lock held %d",
> +			       caller);

s/kernel lock/sb write lock/

> +	reiserfs_write_unlock(s);
> +	mutex_destroy(&REISERFS_SB(s)->lock);
>  	kfree(s->s_fs_info);
>  	s->s_fs_info = NULL;

ah, mutex_destroy() - it's a small detail but still nice ;-)

Anyway, it still looks good to me, after the earlier patch i 
reviewed. Would be nice to have the testing feedback of reiserfs 
users, and the locking review from anyone who knows this code.

	Ingo
