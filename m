Return-Path: <linux-kernel-owner+w=401wt.eu-S1761171AbYGBJ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171AbYGBJ2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYGBJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:28:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42230 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYGBJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:28:42 -0400
To: jmorris@namei.org
CC: miklos@szeredi.hu, jjohansen@suse.de, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, morgan@kernel.org
In-reply-to: <Xine.LNX.4.64.0807021906350.26138@us.intercode.com.au> (message
	from James Morris on Wed, 2 Jul 2008 19:16:40 +1000 (EST))
Subject: Re: [patch] security: fix dummy xattr functions
References: <E1KDmeW-0006KB-2x@pomaz-ex.szeredi.hu>
 <Xine.LNX.4.64.0807021604120.26138@us.intercode.com.au>
 <E1KDwg7-0007OX-5D@pomaz-ex.szeredi.hu> <Xine.LNX.4.64.0807021906350.26138@us.intercode.com.au>
Message-Id: <E1KDydb-0007l9-SY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Jul 2008 11:28:31 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008, James Morris wrote:
> On Wed, 2 Jul 2008, Miklos Szeredi wrote:
> 
> > So where do the dummy_ functions figure into this?  As I understand,
> > they are called whenever LSM is disabled, but the LSM doesn't define a
> > particular hook, so there's a default implementation.  Is that correct?
> 
> If LSM is disabled, nothing is called (the security hooks are optimized 
> away).

Right.  I meant to say "enabled", instead of "disabled" above :)

>  It's for when LSM is enabled, but there is either no LSM module 
> selected, or as fallbacks for hooks which are not implemented by an LSM 
> module.

Yes, we were thinking of the fallback case.  When falling back to the
default, that should be equivalent to the "no LSM" case, no?

Currently it's not.

> > If so, then in theory it is still theoretically possible that with
> > LSM+capabilities, the LSM doesn't explicitly stack inode_setxattr and
> > inode_removexattr, and so the dummy implementation should do that
> > instead.  What am I missing?
> 
> The LSM is responsible for performing this stacking (or not), depending on 
> which particular security models are desired.  It may, for example, not 
> want filesystem capabilities.
> 
> I guess it might be safer to force the LSM to override fs capabilities if 
> it doesn't want them, but I'd like to see what others think.

No, this patch is _not_ forcing anything is LSM defines its own
inode_{set,remove}xattr methods.  I agree, that should be decided by
the LSM.

The patch is just fixing the fallback dummy functions to be in sync
with the the disabled LSM case.

Miklos
