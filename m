Return-Path: <linux-kernel-owner+w=401wt.eu-S1946036AbXDDAEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946036AbXDDAEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992500AbXDDAEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:04:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36090 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946036AbXDDAEL (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:04:11 -0400
Date: Wed, 4 Apr 2007 10:03:54 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, reiserfs-dev@namesys.com
Subject: Re: [xfs-masters] Re: [PATCH] Cleanup and kernelify shrinker registration (rc5-mm2)
Message-ID: <20070404000354.GA32597093@melbourne.sgi.com>
References: <1175571885.12230.473.camel@localhost.localdomain> <20070402205825.12190e52.akpm@linux-foundation.org> <1175575503.12230.484.camel@localhost.localdomain> <20070402215702.6e3782a9.akpm@linux-foundation.org> <1175579225.12230.504.camel@localhost.localdomain> <20070402230954.27840721.akpm@linux-foundation.org> <1175584705.12230.513.camel@localhost.localdomain> <20070403123706.GX32597093@melbourne.sgi.com> <20070403103627.de831e3e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403103627.de831e3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:36:27AM -0700, Andrew Morton wrote:
> On Tue, 3 Apr 2007 22:37:06 +1000 David Chinner <dgc@sgi.com> wrote:
> 
> > On Tue, Apr 03, 2007 at 05:18:25PM +1000, Rusty Russell wrote:
> > > On Mon, 2007-04-02 at 23:09 -0700, Andrew Morton wrote:
> > > This is not about efficiency.  When have I *ever* posted optimization
> > > patches?
> > > 
> > > This is about clarity.  We have a standard convention for
> > > register/unregister.  And they can't fail.  Either of these would be
> > > sufficient to justify a change.
> > > 
> > > Too many people doing cool new things in the kernel, not enough
> > > polishing of the crap that's already there 8(
> > > 
> > > > But I think we need to weed that crappiness out of XFS first.
> > 
> > Can anyone else see the contradiction in these statements?
> > 
> > XFS's "crappiness" is a register/unregister interface.  The only
> > reason it's being removed is because it's getting replaced with a
> > nearly identical register/unregister interface.
> 
> Nope.  XFS is introducing two new typedefs, one of which is identical to
> one which we already have and it has wrapper functions which do little more
> than add new names for existing stuff.

And the problem with that is? You haven't noticed this in the five
years it's been there providing XFS with a consistent shrinker
interface.....

FWIW, digging back into history, Rusty's first patch basically
brings use back to the same interface we had in 2.4. Here's
the 2.4 version of that function:

kmem_shaker_t
kmem_shake_register(kmem_shake_func_t sfunc)
{
        kmem_shaker_t shaker = kmalloc(sizeof(*shaker), GFP_KERNEL);

        if (!shaker)
                return NULL;
        memset(shaker, 0, sizeof(*shaker));
        shaker->shrink = sfunc;
        register_cache(shaker);
        return shaker;
}

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
