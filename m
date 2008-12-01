Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbYLAQdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbYLAQdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYLAQdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:33:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392AbYLAQdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:33:42 -0500
Date: Mon, 1 Dec 2008 08:33:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
cc: linux-kernel@vger.kernel.org, tibor.tajti@gmail.com
Subject: Re: [GIT PULL] UDF tree fixes
In-Reply-To: <20081201120101.GC17303@duck.suse.cz>
Message-ID: <alpine.LFD.2.00.0812010822060.3256@nehalem.linux-foundation.org>
References: <20081127172313.GG32062@duck.suse.cz> <alpine.LFD.2.00.0811301253370.24125@nehalem.linux-foundation.org> <20081201120101.GC17303@duck.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Dec 2008, Jan Kara wrote:
>
>   Yes, I would like to do it as well. But as I write in the changelog,
> currently there's no good callback for that (I've mailed about it at
> linux-fsdevel and noone had a better idea either). So for now I've just
> used this kludge to silence the Oops.

No, I meant just a simple "just call clear_inode() from 
udf_clear_inode()". But on a slightly closer look I notice that won't 
work, since it will just cause recursion (well, you could just clear the 
s_op field to avoid it, but that would be uglier than your fix).

I wonder if we should perhaps just move the invalidate_inode_buffers() 
call later in clear_inode(). That's a scary change, though. 

I just think your patch is pretty ugly. I'm sure it works, but I also 
suspect it indicates some kind of more fundamental problem. I also wonder 
why udf needs it but nobody else does (others do preallocation too)

		Linus
