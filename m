Return-Path: <linux-kernel-owner+w=401wt.eu-S935743AbZDBJny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743AbZDBJny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935376AbZDBJnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:43:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbZDBJnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:43:07 -0400
Date: Thu, 2 Apr 2009 11:43:05 +0200
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc] scale dcache locking
Message-ID: <20090402094305.GE22256@wotan.suse.de>
References: <20090329155539.275927173@nick.local0.net> <20090401142312.GD28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401142312.GD28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 03:23:12PM +0100, Al Viro wrote:
> On Mon, Mar 30, 2009 at 02:55:39AM +1100, npiggin@suse.de wrote:
> > This is my sketch for improving dcache locking scalability. So far I've
> > only really been looking at core code to get an idea of how it might look,
> > so most configurable functionality is broken (and unfortunately it might
> > well be something in there which will cause a fundamental problem for me).
> 
> Umm...  Some of that makes obvious sense per se, some...  In particular,
> all of a sudden we get contention between multiple dput() on the same
> dentry, which is dirt-common for directory ones.

Yes that's true but I'm hoping lock hold times on d_lock aren't
too long, in which case the major cost should remain just the
cacheline contention.

Hmm, I wanted to avoid the atomic because it tends to be covered
by d_lock a lot of the time anyway so avoiding the extra locked op,
and also makes concurrency a bit easier to think about.

In worst case, I guess we need to reintroduce atomic refcount or
have another lock for it...

