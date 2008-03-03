Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYCCOoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYCCOoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbYCCOnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:43:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37136 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYCCOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:43:49 -0500
Date: Mon, 3 Mar 2008 13:08:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: [patch] Re: using long instead of atomic_t when only set/read is
	required
Message-ID: <20080303120842.GA28369@elf.ucw.cz>
References: <20080225090316.GA420@elf.ucw.cz> <Pine.LNX.4.44L0.0802250943410.3549-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802250943410.3549-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Alan thinks that `subj` is correct...
> 
> More precisely, reads and writes of pointers are always atomic.  That 
> is, if a write and a read occur concurrently, it is guaranteed that the 
> read will obtain either the old or the new value of the pointer, never 
> a mish-mash of the two.  If this were not so then RCU wouldn't work.

Ok, so linux actually atomicity of long?

If so, this should probably be applied...

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 4ef2450..0a7d180 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -21,6 +21,9 @@ local_t is very similar to atomic_t. If 
 updated by one CPU, local_t is probably more appropriate. Please see
 Documentation/local_ops.txt for the semantics of local_t.
 
+long (and int and void *) can be used instead of atomic_t, if all you
+need is atomic setting and atomic reading.
+
 The first operations to implement for atomic_t's are the initializers and
 plain reads.
 



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
