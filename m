Return-Path: <linux-kernel-owner+w=401wt.eu-S935726AbZDIS3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935726AbZDIS3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759660AbZDIS3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:29:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758829AbZDIS3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:29:39 -0400
Date: Thu, 9 Apr 2009 11:26:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
In-Reply-To: <20090409181328.GD26366@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0904091120560.4583@localhost.localdomain>
References: <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain> <20090409181328.GD26366@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, Al Viro wrote:
> 
> We can teach patch(1) to handle those - apparently agruen has resurrected
> development lately (git://git.savannah.gnu.org/patch.git), so it might
> be possible without usual latency problems...

I think a lot of SCM's parse diffs internally, so people are still going 
to have to live with legacy patches.

The reason for doing diff parsing internally is that it's much easier to 
handle the error cases, or even just see what files were modified 
successfully.

If you executee an external "patch" command, it's really quite nasty to 
parse the whole "what happened" stuff both for the "everything applied 
fine" _and_ for the "oops, the patch failed in the middle" case. 

Doing diff parsing and application is also generally quite easy - at least 
compared to _generating_ them. In many ways it's easier to just handle the 
diff yourself than it is to try to parse the end result of running "patch" 
externally.

So I would not be at all surprised if many SCM's use an external "diff" to 
generate patches (that has none of the complexities of the error cases), 
but don't use an external "patch" to apply them.

			Linus
