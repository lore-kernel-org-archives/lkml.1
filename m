Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYFCTT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYFCTT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYFCTTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:19:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39293 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYFCTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:19:15 -0400
Date: Tue, 3 Jun 2008 20:18:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603191859.GG28946@ZenIV.linux.org.uk>
References: <20080603104035.GT28946@ZenIV.linux.org.uk> <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu> <20080603105258.GV28946@ZenIV.linux.org.uk> <1212499623.3025.46.camel@raven.themaw.net> <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org> <1212509263.3025.66.camel@raven.themaw.net> <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org> <1212513189.3025.101.camel@raven.themaw.net> <20080603173029.GD28946@ZenIV.linux.org.uk> <x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 01:46:41PM -0400, Jeff Moyer wrote:

> Well, let me know what level of dump you'd like.  I can give the 50,000
> foot view, or I can give you the history of things that happened to get
> us to where we are today, or anything inbetween.  The more specific
> your request, the quicker I can respond.  A full brain-dump would take
> some time!

a) what the hell is going on in autofs4_free_ino()?  It checks for
ino->dentry, when the only caller has just set it to NULL.

b) while we are at it, what's ino->inode doing there?  AFAICS, it's
a write-only field...

c) what are possible states of autofs4 dentry and what's the supposed
life cycle of these beasts?

d)
/* For dentries of directories in the root dir */
static struct dentry_operations autofs4_root_dentry_operations = {
        .d_revalidate   = autofs4_revalidate,
        .d_release      = autofs4_dentry_release,
};

/* For other dentries */
static struct dentry_operations autofs4_dentry_operations = {
        .d_revalidate   = autofs4_revalidate,
        .d_release      = autofs4_dentry_release,
};

Just what is the difference?

e) in autofs4_tree_busy() we do atomic_read() on ino->count and dentry->d_count
What's going to keep these suckers consistent with each other in any useful
way?
