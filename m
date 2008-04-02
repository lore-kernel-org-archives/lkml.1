Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYDBWWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYDBWWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbYDBWV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:21:59 -0400
Received: from pat.uio.no ([129.240.10.15]:44228 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbYDBWV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:21:58 -0400
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080402214824.GP9785@ZenIV.linux.org.uk>
References: <20080402201247.358430231@szeredi.hu>
	 <20080402201321.062856131@szeredi.hu>
	 <20080402205450.GO9785@ZenIV.linux.org.uk>
	 <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu>
	 <20080402214824.GP9785@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 18:21:30 -0400
Message-Id: <1207174890.722.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: F6DE88B01A751A28164A3C56EDC24A513BE7F5A9
X-UiO-SR-test: DCBB99E75C3F673AB95329F3B962C575C99FCF80
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 162 total 7672709 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 22:48 +0100, Al Viro wrote:
> I disagree.  First of all, clear separation between operations on
> _filesystem_, which should all be namespace-agnostic and things
> that depend on vfsmount is a Good Thing(tm).  Think of that as
> of separation between server (superblock and everything related
> to it, starting with dentry tree) and clients; mixing those is a
> bloody bad idea.

Speaking of which: is there any reason why we can't get rid of the
vfsmount reference in struct file?

Most file operations, don't involve namespace traversal at all: aside
from fchdir(), and the *at() functions (all of which take file
descriptors, not pointers to struct file) the only function of that
vfsmount reference appears to be to prevent the superblock from going
away.

Cheers
  Trond

