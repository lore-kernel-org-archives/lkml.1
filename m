Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbZBXQ1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbZBXQ1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZBXQ1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:27:20 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:46983 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZBXQ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:27:19 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: New filesystem for Linux kernel 
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: tomas@slax.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1LbycM-0007FV-Rg@pomaz-ex.szeredi.hu>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu> <11287.1235481490@jrobl> <E1LbycM-0007FV-Rg@pomaz-ex.szeredi.hu>
Date: Wed, 25 Feb 2009 01:26:59 +0900
Message-ID: <15922.1235492819@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> It's always easier to review something with less features, even if
> that feature set is too little for real world use.

Generally I agree with you.


> The simplest version is with all branches read-only.  That gets rid of
> a _huge_ amount of complexity, yet it's still useful in some
> situations.  It also deals with a lot of the basic infrastucture
> needed for stacking.

If you really think it is a better way to get merged into mainline, then
I'll try implement such version.


> And that's when one starts thinking about whether unioning is really
> the right solution.  Instead this could be implemented with a special
> filesystem format that only contains deltas to the data, metatata and
> directory tree.  It would be much more space efficient, could easily
> handle renames, hard links etc, without all the hacks that
> unionfs/aufs does.

It sounds like an ODF (on disk format) version of unionfs (while it
seems to be inactive).
At implementing, I don't think it easier to maintain delta of filedata
and metadata. Since aufs has a writable branch in it, it is better and
easier to maintain data in a branch fs.
If you think there should not be any writable branch in aufs, and all
"write" goes to a new filesystem format, then it is equivalent to a
writable branch, isn't it?
If you say "just a part of write" goes to a new fs, then I don't think
we can support several essential features, for instance mmap.


J. R. Okajima
