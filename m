Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYI1WHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYI1WHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 18:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYI1WHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 18:07:22 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58342 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbYI1WHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 18:07:21 -0400
Date: Sun, 28 Sep 2008 23:07:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
In-Reply-To: <alpine.LFD.1.10.0809281355540.3265@nehalem.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0809282258320.12346@blonde.site>
References: <20080926152031.GA30831@x200.localdomain>
 <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org>
 <20080928141856.GG28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0809282011020.1967@blonde.site>
 <alpine.LFD.1.10.0809281350410.3265@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809281355540.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2008, Linus Torvalds wrote:
> On Sun, 28 Sep 2008, Linus Torvalds wrote:
> > 
> > NOTE! Totally untested patch! It looks sane and really obvious, but maybe 
> > it has some insane and non-obvious bug.

Looks good to me, nicer than the first, and would have prevented my
oops today (if I'm interpreting it correctly: certainly I do have
DCACHE_UNHASHED set).

> 
> Oh. I think I see at least a _potential_ insane and non-obvious bug: if 
> somebody actually is going to do a __d_drop() _inside_ their d_compare(), 
> this would fail horribly because we now assume that the dentry is still 
> fine, since we held d_lock.
> 
> Of course, I think that would be very very buggy of a filesystem to do (we 
> don't even pass in the dentry as an argument - you have to figure it out 
> from the qstr, and a filesystem really should not do that!), but /proc 
> _does_ look up the dentry in question, maybe some other insane filesystem 
> does too and then does the __d_drop.

I agree that would be insane.  There's no end to the weird things
a filesystem _could_ do in its d_compare, but it is supposed to be
about comparison, and every filesystem I can see in the tree treats
it as such.

> 
> I'm not seeing it, though. So I still think the patch is sane and good, 
> but somebody really needs to double- or triple-check me on it.

Hugh
