Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbZFPPTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbZFPPTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZFPPTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:19:23 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55212 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZFPPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:19:22 -0400
To: vaurora@redhat.com
CC: miklos@szeredi.hu, jblunck@suse.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
In-reply-to: <20090608194404.GC4363@fsbox> (message from Valerie Aurora on
	Mon, 8 Jun 2009 12:44:04 -0700)
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu> <20090519172327.GB722@shell> <E1M6hjr-00032A-EX@pomaz-ex.szeredi.hu> <20090608194404.GC4363@fsbox>
Message-Id: <E1MGaRG-0005z5-BR@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 16 Jun 2009 17:19:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Valerie Aurora wrote:
> On Wed, May 20, 2009 at 11:05:27AM +0200, Miklos Szeredi wrote:

> > The big reason why kernel impementation of readdir is hard is that
> > unswappable kernel memory needs to be used for caching directory
> > contents while the directory is open.  Well, tmpfs does the same,
> > dentries and inodes are _not_ swappable, and they gobble up memory.
> 
> That's a good point.  It seemed to me that it wouldn't be too
> difficult to make those entries evictable - drop a reference count and
> set the ->d_release to mark the directory as needing rebuilding.  What
> do you think?

AFAICS, there are nontrivial problems to deal with:

If directory is still open, child dentries must not go away.

If directory is closed, and at least one child is evicted, then the
whole directory is unusable and needs to be rebuilt on next readdir.

If we can solve those in a non-racy way than it might work.  I suspect
however, that some additional code in union-mounts that adds all this
functionality without reusing tmpfs would actually be simpler to
implement.

Thanks,
Miklos
