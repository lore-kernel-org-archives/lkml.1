Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0CGETY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 23:19:24 -0500
Received: from netrider.rowland.org ([192.131.102.5]:43376 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753425Ab0CGETW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 23:19:22 -0500
Date: Sat, 6 Mar 2010 23:19:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: The gregkh patch scripts
Message-ID: <Pine.LNX.4.44L0.1003062253101.29076-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg:

Are the scripts you use for creating the various gregkh-*.patch files 
stored in 

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/scripts/

?  Those files appear not to have been updated for quite some time.

Regardless, the way the current scripts work has got a problem.  As far
as I can tell, they take Linus's current tree, apply your various
accumulated quilt series files, and then compute the diff between the
end result and the starting point.  The output is labelled with name of
the starting tree.  (If my understanding is wrong then tell me so and
ignore the rest of this message.)

The problem is that Linus's current tree is not a good starting point.  
For example, right now several of the individual files such as
gregkh-07-usb-2.6.33.patch are completely empty.  This is because you
have sent all the pending changes upstream, so they are now included in
Linus's tree and hence they don't show up in a diff.

But...  The file is still named "gregkh-07-usb-2.6.33.patch", even
though it isn't a patch against 2.6.33 -- it's a patch against whatever
Linus's tree happened to contain at the time you ran the script.  
Since I don't know what tree that was (and I don't have git repository
for the kernel anyway), I can't use the patch file.  (Well, I _can_ use 
it because it's empty, but it doesn't do me any good -- the principle 
is still valid.)

As Linus has explained to quite a few people, this isn't a good way to
operate.  What your scripts do is essentially the same as rebasing a
publicly-exported git repository, which should be done relatively
infrequently.  It's okay to rebase against the actual releases and the
*-rcN trees, because they are well-defined intermediate points.  But
rebasing against a *-rcN-gitM should be quite rare, and rebasing
against anything else is basically forbidden.

This means the scripts shouldn't start with the vanilla
tree-of-the-moment.  They should start with the most recent release or
-rcN tag.  In rare cases they could use an rcN-gitM tag, but only if
there's a good reason.

So for example, the current gregkh-*-2.6.33.patch files should be quite
large, because they should contain all the accumulated development for
the last three months that hasn't gotten into 2.6.33.  When 2.6.34-rc1
is released then the files should get small, since they would then
contain only material that was submitted slightly before or during the
merge window.

Can the scripts be updated to work in this way?

Alan Stern

