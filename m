Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYCNUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYCNUnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758665AbYCNUmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:42:51 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55290 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641AbYCNUmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:42:50 -0400
Date: Fri, 14 Mar 2008 14:42:48 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: sfr@canb.auug.org.au, lenb@kernel.org, dhowells@redhat.com,
       peterz@infradead.org, mingo@elte.hu, harvey.harrison@gmail.com
Subject: Updated generic semaphore patch set
Message-ID: <20080314204248.GV613@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've pushed out a new version of the semaphore tree.  I'll send the new
patches as a reply to this mail.

git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git semaphore-20080314

Changes:
 - Dropped all the asm/semaphore.h changes.  They're just causing
   conflicts for linux-next, and while Stephen assures me that fixing
   them up is trivial and he doesn't mind, I'd rather not burn him out
   prematurely.  I still intend to push them, but they don't need to be
   part of linux-next, IMO.
 - Split the addition of down_killable() out of the main patch.  It's
   logically separate (adding a new interface), and it was sheer
   laziness to not split it out in the first place.
 - New functionality!  down_timeout().  Just look at the mess in
   acpi/osl.c where it tries to emulate it.  It's very little extra code
   to add it to kernel/semaphore.c, so I thought it was a good idea.
 - Simplify the implementation.  Dave Howells said the current algorithm
   makes his head hurt, and in retrospect, perhaps I was just trying to
   be too clever.
 - Fix the lockdep bug (thanks to Peter Zijlstra)
 - Remove an unsightly and unnecessary unlikely() (thanks to Harvey Harrison)
 - Fix the down() while interrupts disabled bug (thanks to Ingo Molnar)
   (I may have posted this one before.  Not sure.)

I've tested the end result of this with Dave Howells' synchro-test module
and not found any problems.

If you prefer, you can also find the patches at
http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=semaphore-20080314

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
