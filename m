Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYKPXZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYKPXZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYKPXY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:24:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570AbYKPXY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:24:57 -0500
Date: Sun, 16 Nov 2008 15:23:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Peter Palfrader <peter@palfrader.org>, linux-kernel@vger.kernel.org
Subject: Re: Fix broken ownership of /proc/sys/ files
In-Reply-To: <20081116221910.GQ28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0811161515040.9657@nehalem.linux-foundation.org>
References: <20081116205922.GI28958@anguilla.noreply.org> <20081116221910.GQ28946@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Nov 2008, Al Viro wrote:
>
> D'oh...

So I applied this, but I wonder if it might not be nice to make 
new_inode() (or rather - 'alloc_inode()') initialize some more of the 
really core members.

We already initialize a _lot_ of fields, including fields that most 
filesystem would likely end up re-initializing when reading an inode (like 
i_size and i_nlink). Maybe it would be more sensible to initialize 
i_gid/uid there too, when we are guaranteed to have that cacheline dirty 
anyway (because we're initializing everything around those fields).

But I guess it's not a huge deal. 

		Linus
