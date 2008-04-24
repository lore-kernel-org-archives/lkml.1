Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYDXOpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYDXOpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYDXOoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:44:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58634 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYDXOox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:44:53 -0400
Date: Thu, 24 Apr 2008 15:44:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424144448.GH15214@ZenIV.linux.org.uk>
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <E1Jp28U-0003r3-8r@pomaz-ex.szeredi.hu> <20080424142857.GF15214@ZenIV.linux.org.uk> <E1Jp2Yw-0003xF-Fk@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jp2Yw-0003xF-Fk@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 04:36:38PM +0200, Miklos Szeredi wrote:
> > RTFS.  permission() doesn't do "is that vfsmount read-only" checks, exactly
> > because it's 100% bogus - either you cover it with entire area where we
> > are guaranteed to stay r/w, or it's by definition racy.
> 
> I know that.
> 
> That does not mean, that fh_verify() needs to do vfsmount r/o checks.
> AFAICS it's perfectly OK to do that later, around the vfs_ call.

... and around everything else that happens to be done after fh_verify
for write access, surely?  Note that e.g. nfsd_setattr() does _not_ call
vfs_<anything>()...

BTW, that assumes we want to do these checks for nfsd at access time.
And not go for _exports_ being r/w or r/o, with protection applying to
the entire lifetime of export.
