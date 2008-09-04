Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbYIDWVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbYIDWVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 18:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbYIDWU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 18:20:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791AbYIDWU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 18:20:56 -0400
Date: Fri, 5 Sep 2008 00:20:35 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, neilb@suse.de
Subject: Re: [PATCH] nfsd/nfs4acl: Number of used used array elements needs
 to be zeroed.
Message-ID: <20080905002035.5c7abde1@psychotron.englab.brq.redhat.com>
In-Reply-To: <20080904150101.GB4536@fieldses.org>
References: <20080904165518.15a02908@psychotron.englab.brq.redhat.com>
	<20080904150101.GB4536@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 11:01:01 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Thu, Sep 04, 2008 at 04:55:18PM +0200, Jiri Pirko wrote:
> > Number of used used array elements needs to be zeroed. It may cause
> > problems otherwise, because it's used uninitialized in find_uid().
> > 
> > Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> > ---
> >  fs/nfsd/nfs4acl.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
> > index 54b8b41..7dcd90f 100644
> > --- a/fs/nfsd/nfs4acl.c
> > +++ b/fs/nfsd/nfs4acl.c
> > @@ -447,11 +447,13 @@ init_state(struct posix_acl_state *state, int cnt)
> >  	state->users = kzalloc(alloc, GFP_KERNEL);
> >  	if (!state->users)
> >  		return -ENOMEM;
> > +	state->users->n = 0;
> >  	state->groups = kzalloc(alloc, GFP_KERNEL);
> >  	if (!state->groups) {
> >  		kfree(state->users);
> >  		return -ENOMEM;
> >  	}
> > +	state->groups->n = 0;
> >  	return 0;
> >  }
> 
> Thanks for the extra eyes on this code, but: surely the kzalloc()'s are
> all that's necessary?  Am I missing something?
Sure you are right. Sorry, my bad...

Jirka
> 
> --b.
