Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYGBJRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYGBJRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYGBJRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:17:23 -0400
Received: from namei.org ([69.55.235.186]:32981 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464AbYGBJRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:17:22 -0400
Date: Wed, 2 Jul 2008 19:16:40 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jjohansen@suse.de, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, morgan@kernel.org
Subject: Re: [patch] security: fix dummy xattr functions
In-Reply-To: <E1KDwg7-0007OX-5D@pomaz-ex.szeredi.hu>
Message-ID: <Xine.LNX.4.64.0807021906350.26138@us.intercode.com.au>
References: <E1KDmeW-0006KB-2x@pomaz-ex.szeredi.hu>
 <Xine.LNX.4.64.0807021604120.26138@us.intercode.com.au>
 <E1KDwg7-0007OX-5D@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008, Miklos Szeredi wrote:

> So where do the dummy_ functions figure into this?  As I understand,
> they are called whenever LSM is disabled, but the LSM doesn't define a
> particular hook, so there's a default implementation.  Is that correct?

If LSM is disabled, nothing is called (the security hooks are optimized 
away).  It's for when LSM is enabled, but there is either no LSM module 
selected, or as fallbacks for hooks which are not implemented by an LSM 
module.

> If so, then in theory it is still theoretically possible that with
> LSM+capabilities, the LSM doesn't explicitly stack inode_setxattr and
> inode_removexattr, and so the dummy implementation should do that
> instead.  What am I missing?

The LSM is responsible for performing this stacking (or not), depending on 
which particular security models are desired.  It may, for example, not 
want filesystem capabilities.

I guess it might be safer to force the LSM to override fs capabilities if 
it doesn't want them, but I'd like to see what others think.


- James
-- 
James Morris
<jmorris@namei.org>
