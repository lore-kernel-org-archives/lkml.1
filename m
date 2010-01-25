Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674Ab0AYXOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0AYXOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106Ab0AYXOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:14:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38032 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0AYXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:14:18 -0500
Date: Mon, 25 Jan 2010 23:14:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       davem@davemloft.net, netdev@vger.kernel.org, x86@kernel.org,
       mingo@redhat.com, fweisbec@gmail.com, dan.j.williams@intel.com,
       borislav.petkov@amd.com, ying.huang@intel.com, lenb@kernel.org,
       neilb@suse.de, cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: add __percpu sparse annotations
Message-ID: <20100125231411.GA19799@ZenIV.linux.org.uk>
References: <1264432935-10453-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264432935-10453-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 12:22:07AM +0900, Tejun Heo wrote:
> This patchset adds __percpu sparse annotations to all percpu users
> covered by x86_64 allmodconfig.  __percpu annotation teaches sparse
> that percpu variables live in a separate address space and can't be
> accessed directly without going through percpu accessors.  This allows
> detection of most percpu access mistakes involving both static and
> dyanmic percpu variables.
> 
> This patchset contains the following eight patches.
> 
>  0001-percpu-add-__percpu-sparse-annotations-to-core-kerne.patch
>  0002-percpu-add-__percpu-sparse-annotations-to-fs.patch
>  0003-percpu-add-__percpu-sparse-annotations-to-net.patch
>  0004-percpu-add-__percpu-sparse-annotations-to-net-driver.patch
>  0005-percpu-add-__percpu-sparse-annotations-to-x86.patch
>  0006-percpu-add-__percpu-sparse-annotations-to-trace.patch
>  0007-percpu-add-__percpu-sparse-annotations-to-hw_breakpo.patch
>  0008-percpu-add-__percpu-sparse-annotations-to-what-s-lef.patch
> 
> As these annotations are for sparse, none of the above patches affects
> normal kernel build and most of the conversions are straight-forward
> and trivial.  There are a few places where the conversion isn't
> completely straight-forward (but still fairly trivial).  Those are
> mentioned in each patch description.
> 
> I can route the patch through percpu and conflict resolution, if
> necessary, wouldn't be difficult at all for these changes.  If anyone
> wants to route one of these patches through a different tree, please
> let me know.  All that's necessary would be adding dummy __percpu
> definition to the patch.
> 
> If nobody objects, I'll push these into percpu tree in three or four
> days.

Um.  Where *is* the definition of __percpu?  Presumably, that'd be
something like __attribute__((noderef,address_space(4)) under ifdef
__CHECKER__ and empty otherwise?  If so, I'm fine with that patchset,
provided that it does grow that #define and becomes self-contained...
