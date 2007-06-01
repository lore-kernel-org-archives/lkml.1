Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbXFADII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbXFADII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 23:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXFADH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 23:07:56 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:46007 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbXFADH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 23:07:56 -0400
Date: Thu, 31 May 2007 23:07:54 -0400
From: Kyle McMartin <kyle@parisc-linux.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Chris Zankel <chris@zankel.net>, parisc-linux@lists.parisc-linux.org
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
Message-ID: <20070601030754.GB14217@fattire.cabal.ca>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com> <20070531162021.4cd4e91a.akpm@linux-foundation.org> <20070601113840.813463db.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601113840.813463db.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 11:38:40AM +1000, Stephen Rothwell wrote:
> This also breaks Alpha (which uses 02000000 for O_DIRECT) and parisc
> (which uses 02000000 for O_RSYNC).  So you ether need to choose a
> different value or define O_CLOEXEC for those two architectures.
> 

That's easy enough to fix...

Signed-off-by: Kyle McMartin <kyle@parisc-linux.org>

diff --git a/include/asm-parisc/fcntl.h b/include/asm-parisc/fcntl.h
index 317851f..4ca0fb0 100644
--- a/include/asm-parisc/fcntl.h
+++ b/include/asm-parisc/fcntl.h
@@ -14,6 +14,7 @@
 #define O_DSYNC		01000000 /* HPUX only */
 #define O_RSYNC		02000000 /* HPUX only */
 #define O_NOATIME	04000000
+#define O_CLOEXEC	08000000 /* set close_on_exec */
 
 #define O_DIRECTORY	00010000 /* must be a directory */
 #define O_NOFOLLOW	00000200 /* don't follow links */
