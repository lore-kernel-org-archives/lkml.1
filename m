Return-Path: <linux-kernel-owner+w=401wt.eu-S1765287AbYDXPb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765287AbYDXPb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763020AbYDXPWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:22:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56310 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYDXPWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:22:06 -0400
Date: Thu, 24 Apr 2008 16:21:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424152129.GK15214@ZenIV.linux.org.uk>
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk> <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu> <20080424143537.GG15214@ZenIV.linux.org.uk> <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu> <20080424144815.GI15214@ZenIV.linux.org.uk> <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 04:58:00PM +0200, Miklos Szeredi wrote:

> Since all the vfs_* functions will become static with path_* being the
> only caller, the compiler will be happy to get rid of that stack frame
> too.
> 
> What is left is the guarantee, that the race-free r/o remounts will
> always work and some obscure caller didn't forget to surround it with
> the r/o checks.
> 
> I think it's definitely worth it.

It would be, if we had only single vfs_...() as critical sections.  We
do not - see previous mail or read the fucking tree, already.

We don't even have many callers of each, and with a few we do it's not
obvious that we want to go through vfsmounts (and vfsmount-based checks)
in all of them.  So no, I don't buy your argument.  Sorry.

I'm not even convinced that they are useful as helpers, at least until
we'd decided what to do with checks in nfsd.  Until then we do, as
far as I'm concerned, one place where they would definitely DTRT - fs/namei.c.
And I want more than one caller before merging those, let alone removing
the interface that doesn't require checks to be vfsmount-based for all users.
