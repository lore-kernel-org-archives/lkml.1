Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbZBXOvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbZBXOvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZBXOu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:50:58 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51950 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120AbZBXOu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:50:57 -0500
To: hooanon05@yahoo.co.jp
CC: miklos@szeredi.hu, tomas@slax.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <11287.1235481490@jrobl> (hooanon05@yahoo.co.jp)
Subject: Re: New filesystem for Linux kernel
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu> <11287.1235481490@jrobl>
Message-Id: <E1LbycM-0007FV-Rg@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Feb 2009 15:50:42 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, hooanon05@yahoo.co.j wrote:
> I have to admit aufs is big, but actually, as I wrote in the documents,
> aufs2 has already dropped several features. And I believe it is the core
> feature set. If aufs2 drops some more features, then both of users and
> reviewers will say it doesn't work in this case, in that case. I don't
> think you would like to review such unusable code in real world.

It's always easier to review something with less features, even if
that feature set is too little for real world use.

Maybe it has all got to get into mainline to be really useful, but
still, splitting it up by functionality (not just files) helps
reviewers a lot.

Let's see this feature list:

> 1. Features
> ----------------------------------------
> - unite several directories into a single virtual filesystem. The member
>   directory is called as a branch.

Sounds like a core functionality :)

> - you can specify the permission flags to the branch, which are 'readonly',
>   'readwrite' and 'whiteout-able.'

The simplest version is with all branches read-only.  That gets rid of
a _huge_ amount of complexity, yet it's still useful in some
situations.  It also deals with a lot of the basic infrastucture
needed for stacking.

> - by upper writable branch, internal copyup and whiteout, files/dirs on
>   readonly branch are modifiable logically.

Right.  The second most simple version is all branches read-only except the
top one.

And that's when one starts thinking about whether unioning is really
the right solution.  Instead this could be implemented with a special
filesystem format that only contains deltas to the data, metatata and
directory tree.  It would be much more space efficient, could easily
handle renames, hard links etc, without all the hacks that
unionfs/aufs does.

Has this been discussed somewhere?

Thanks,
Miklos
