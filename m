Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZETKVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZETKVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbZETKVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:21:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33198 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZETKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:21:22 -0400
To: vaurora@redhat.com
CC: miklos@szeredi.hu, jblunck@suse.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
In-reply-to: <20090519173038.GC722@shell> (message from Valerie Aurora on Tue,
	19 May 2009 13:30:38 -0400)
Subject: Re: [PATCH 21/32] union-mount: Make lookup work for union-mounted file systems
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1242662968-11684-22-git-send-email-jblunck@suse.de> <E1M6Ryq-0001RP-Oe@pomaz-ex.szeredi.hu> <20090519173038.GC722@shell>
Message-Id: <E1M6iv8-0003CB-4O@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 20 May 2009 12:21:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, Valerie Aurora wrote:
> On Tue, May 19, 2009 at 06:15:52PM +0200, Miklos Szeredi wrote:

> > Worse, it looks like there are still i_mutex lock ordering issues
> > (__hash_lookup_topmost()/__hash_lookup_build_union()).  What happens
> > if two separate unions of two filesystems are built where the order of
> > branches is reversed?
> 
> We have a similar problem in union_copyup_dir().  Hm, thinking about
> this, only one of the file systems can actually change while we are
> doing work.  That might help us get out of the lock ordering problems.
> Thoughts?

Right, we talked about this with Jan, and came basically to the same
conclusion.  The lookup on the lower branches needs to be separate
from the atomic lookup/create on the top branch.  Which means some
restructuring in the callers...

I'm not sure how all this could be simplified, I don't yet even
understand what all these different lookup functions are meant to do
(header comments might help).

Thanks,
Miklos
