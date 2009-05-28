Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZE1IJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZE1IJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZE1IJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:09:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52675 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbZE1IJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:09:12 -0400
Date: Thu, 28 May 2009 10:15:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86: MCE: Fix for mce_panic_timeout
Message-ID: <20090528081549.GC1065@one.firstfloor.org>
References: <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com> <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com> <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com> <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com> <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com> <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com> <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com> <4A1CC21A.10301@jp.fujitsu.com> <874ov6oo3t.fsf@basil.nowhere.org> <4A1DE067.9090408@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1DE067.9090408@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 09:52:55AM +0900, Hidetoshi Seto wrote:
> Andi Kleen wrote:
> > Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:
> >>  - In case of panic_timeout > 0 and mce_bootlog == 0.
> >>    System should reboot after panic, but it doesn't on mce panic because
> >>    current mce code overwrite panic_timeout to 0.
> > 
> > Nope, with bootlog==0 it should _not_ automatically reboot on panic.
> > Automatic rebooting makes mainly sense with boot logging, otherwise
> > you will likely lose the information. Or at least the kernel 
> > cannot know if you lose information or not so it has to err on 
> > the safe side.
> 
> Users already know they might lose the information about the panic
> if panic_timeout > 0.  It is same on all kind of panic.

Yes if they set panic=..., but they don't expect it by default as
this patch does.

> 
> > I changed it now to only override with panic_timeout == 0,
> > as in the user didn't set anything,
> > that's probably the most sensible semantics anyways.
> 
> It's OK with me.
> The logic in this patch also seems good.

Thanks.

> 
> But...
> 
> > v2: Only force panic timeout when it's shorter (H.Seto)
> > v3: Only panic when there is no earlier timeout or it's not zero
> > (based on comment H.Seto)
> 
> "Only panic when ..." ?
> I could not cache the meaning of this changelog.

"Only automatically panic ..."

Ok fair enough, if I ever redo a repost I'll update that line, but I hope
I don't have to touch this trivial patch anymore.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
