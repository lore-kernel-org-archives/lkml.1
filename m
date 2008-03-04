Return-Path: <linux-kernel-owner+w=401wt.eu-S1763870AbYCDPCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763870AbYCDPCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbYCDPCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:02:35 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57639 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbYCDPCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:02:35 -0500
Date: Tue, 4 Mar 2008 08:02:13 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Make Andrew's life easier
Message-ID: <20080304150213.GI24386@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew recently complained that feature-removal-schedule.txt is always
generating conflicts.  The reason is clear; everybody adds to the
bottom of the file.  The solution he proposed is to place entries at
random places in the file.  However, we can make the tools work for
us here quite simply by adding a separator at the bottom of the file.
Then diff produces a patch which contains no meaningful context and
patch will happily put new entries into the file in a random order.
Unfortunately, git-cherry-pick won't, but I don't think Andrew uses it,
so he'll be happy anyway.

This will fail if people subsequently fail to add a separator at the
bottom of a file.  But then those people can be legitimately grumped at.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c1d1fd0..325e5b4 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -328,3 +328,6 @@ Why:	Not used in-tree. The current out-of-tree users used it to
 	code / infrastructure should be in the kernel and not in some
 	out-of-tree driver.
 Who:	Thomas Gleixner <tglx@linutronix.de>
+
+---------------------------
+

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
