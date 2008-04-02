Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYDBWhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYDBWhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYDBWhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:37:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42345 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbYDBWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:36:59 -0400
Date: Wed, 2 Apr 2008 23:36:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080402223637.GQ9785@ZenIV.linux.org.uk>
References: <20080402201247.358430231@szeredi.hu> <20080402201321.062856131@szeredi.hu> <20080402205450.GO9785@ZenIV.linux.org.uk> <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu> <20080402214824.GP9785@ZenIV.linux.org.uk> <1207174890.722.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207174890.722.12.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 06:21:30PM -0400, Trond Myklebust wrote:
> On Wed, 2008-04-02 at 22:48 +0100, Al Viro wrote:
> > I disagree.  First of all, clear separation between operations on
> > _filesystem_, which should all be namespace-agnostic and things
> > that depend on vfsmount is a Good Thing(tm).  Think of that as
> > of separation between server (superblock and everything related
> > to it, starting with dentry tree) and clients; mixing those is a
> > bloody bad idea.
> 
> Speaking of which: is there any reason why we can't get rid of the
> vfsmount reference in struct file?
> 
> Most file operations, don't involve namespace traversal at all: aside
> from fchdir(), and the *at() functions (all of which take file
> descriptors, not pointers to struct file) the only function of that
> vfsmount reference appears to be to prevent the superblock from going
> away.

Huh?  Are you proposing to move that to descriptor table, of all things?
Not to mention SCM_RIGHTS datagrams and hell knows what else...
