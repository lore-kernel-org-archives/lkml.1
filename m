Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966400Ab0BZWDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 17:03:02 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:60427 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966337Ab0BZWDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 17:03:00 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO7Th0urRN+K/2dsb2JhbACbH3Ojapg3hHkEgxg
X-IronPort-AV: E=Sophos;i="4.49,548,1262563200"; 
   d="scan'208";a="157651528"
From: Roland Dreier <rdreier@cisco.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the infiniband tree with the vfs tree
References: <20100226130518.94c5a5f8.sfr@canb.auug.org.au>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 26 Feb 2010 14:02:55 -0800
In-Reply-To: <20100226130518.94c5a5f8.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Fri, 26 Feb 2010 13:05:18 +1100")
Message-ID: <adazl2vvenk.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Today's linux-next merge of the infiniband tree got a conflict in
 > drivers/infiniband/core/uverbs_main.c between commit
 > ce916e2b935f8b3402da1457ff23b9f9f786c09b ("switch infiniband uverbs to
 > anon_inodes") from the vfs tree and commit
 > 4169c4a9735d6434c9e39fa81ae5517e3afd4cd8 ("IB/uverbs: Use anon_inodes
 > instead of private infinibandeventfs") from the infiniband tree.
 > 
 > These two commits purport to do something similar.  Someone should look
 > at them both and decide which one is right.  For now I have used the
 > version from the vfs tree - with the addition of the part from the
 > infiniband tree version that selects ANON_INODES in the Kconfig file.

Huh, I didn't see that vfs commit and as far as I can tell it was never
posted anywhere.  Which I guess is why we have linux-next :)

Anyway, both commits look essentially equivalent -- Al's moves the fd
allocation to callers, which is OK with me (a bit of duplicated code but
maybe a bit better layering of functions).  I would like to see the
Kconfig part go in as part of the patch, although I guess it's not such
a terrible bit of breakage to fix up a bit after the fact.  (Not a real
bisection killer)

Al, let me know what you want to do -- I can pick up your patch or drop
the patch from my tree, either way is fine.

 - R.
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
