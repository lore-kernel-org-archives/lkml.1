Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbZEAUFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbZEAUFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbZEAUFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:05:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444AbZEAUFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:05:34 -0400
Date: Fri, 1 May 2009 12:59:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/6] kill-the-BKL/reiserfs3: performance improvements,
 faster than Bkl based scheme
In-Reply-To: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.LFD.2.00.0905011236530.5379@localhost.localdomain>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 May 2009, Frederic Weisbecker wrote:
> 
> This reiserfs patchset applies against latest tip:core/kill-the-BKL
> It adds various explicit write lock releases on specific sleeping sections.

Btw, is there any reason why it cannot just be re-based on top of standard 
-rc4?

I'd love to pull a "reiserfs: remove bkl" branch when the next merge 
window opens, but there's no way I'll pull the kill-bkl thing with all the 
odd random tty stuff etc that is totally unrelated.

And as far as I can tell, all your reiserfs patches are totally unrelated 
to all other changes, and it would be _much_ nicer to just merge the 
reiserfs ones.

So there's
 - the filesystem mount bkl pushdown

 - the reiserfs series

and quite frankly, I'll happily take the straightforward BKL pushdown, but 
I do _not_ want to see this mix-up with all the tty stuff, or even the NFS 
and RPC changes. 

In fact, if it makes it easier for people to merge, I can take the pure 
VFS push-down that was already Ack'ed by Al. But the rest of the stuff 
really isn't appropriate. 

For example, every single

	remove the BKL: remove "BKL auto-drop" assumption from xyz

patch in that series is pure and utter crap. I'm not going to take things 
like that. But it looks like your reiserfs patches really are totally 
independent of everything else, and should be merged as such.

		Linus
