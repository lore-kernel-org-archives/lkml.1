Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZIGHid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZIGHid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZIGHic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:38:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZIGHic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:38:32 -0400
Date: Mon, 7 Sep 2009 09:38:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 16/33] fs: dcache per-bucket dcache hash locking
Message-ID: <20090907073834.GF1875@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net> <20090904065536.424606052@nick.local0.net> <1252075897.22928.23.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252075897.22928.23.camel@desktop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 07:51:37AM -0700, Daniel Walker wrote:
> On Fri, 2009-09-04 at 16:51 +1000, npiggin@suse.de wrote:
> > +/* This should be called _only_ with a lock pinning the dentry */
> > +static inline struct dentry * __dget_locked_dlock(struct dentry
> > *dentry)
> > +{
> > +       dentry->d_count++;
> > +       dentry_lru_del_init(dentry);
> > +       return dentry;
> > +}
> > +
> > +static inline struct dentry * __dget_locked(struct dentry *dentry)
> > +{
> 
> Could you run your series through checkpatch, and clean up at least any
> errors you find..

Sure, I'll try to remember to do that at some point. fs/ code has a lot of
space after *, which I don't always fix up (and arguably is a clearer way
write pointer types). But yeah I'm happy to follow checkpatch style.


