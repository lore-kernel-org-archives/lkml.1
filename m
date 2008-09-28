Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYI1VAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYI1VAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 17:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYI1VAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 17:00:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbYI1VAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 17:00:12 -0400
Date: Sun, 28 Sep 2008 13:59:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
In-Reply-To: <alpine.LFD.1.10.0809281350410.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809281355540.3265@nehalem.linux-foundation.org>
References: <20080926152031.GA30831@x200.localdomain> <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org> <20080928141856.GG28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0809282011020.1967@blonde.site>
 <alpine.LFD.1.10.0809281350410.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Sep 2008, Linus Torvalds wrote:
> 
> NOTE! Totally untested patch! It looks sane and really obvious, but maybe 
> it has some insane and non-obvious bug.

Oh. I think I see at least a _potential_ insane and non-obvious bug: if 
somebody actually is going to do a __d_drop() _inside_ their d_compare(), 
this would fail horribly because we now assume that the dentry is still 
fine, since we held d_lock.

Of course, I think that would be very very buggy of a filesystem to do (we 
don't even pass in the dentry as an argument - you have to figure it out 
from the qstr, and a filesystem really should not do that!), but /proc 
_does_ look up the dentry in question, maybe some other insane filesystem 
does too and then does the __d_drop.

I'm not seeing it, though. So I still think the patch is sane and good, 
but somebody really needs to double- or triple-check me on it.

		Linus
