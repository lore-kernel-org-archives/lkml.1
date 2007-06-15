Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbXFOP4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbXFOP4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXFOP4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:56:38 -0400
Received: from styx.suse.cz ([82.119.242.94]:50337 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751064AbXFOP4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:56:37 -0400
Date: Fri, 15 Jun 2007 18:09:44 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rich Coe <Richard.Coe@med.ge.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: Re: PATCH: udf fs corruption on linux-2.6
Message-ID: <20070615160944.GA29775@duck.suse.cz>
References: <20070613154803.a1ad874a.Richard.Coe@med.ge.com> <20070614163218.1d75dda4.Richard.Coe@med.ge.com> <alpine.LFD.0.98.0706141511110.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706141511110.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-06-07 15:12:58, Linus Torvalds wrote:
> 
> 
> On Thu, 14 Jun 2007, Rich Coe wrote:
> >
> > I've updated the patch below to use drop_inode rather than put_inode.
> > 
> > drop_inode is only called when the last iput() reference to the inode is
> > released, where put_inode is called for every iput().
> 
> Patch looks fine, but this late in the -rc series, I'd really like to get 
> an ACK from Jan or somebody else, just to make sure there are no other 
> issues with it.
> 
> Jan? 
  My fix for this problem is already sitting in Andrew's patch queue
(http://lkml.org/lkml/2007/6/11/79). Rich's patch still has a problem - you
cannot call udf_discard_prealloc() from drop_inode() because it is called
under inode_lock and thus you cannot call e.g. mark_inode_dirty(). I've done
that mistake too ;). So please don't apply the patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
