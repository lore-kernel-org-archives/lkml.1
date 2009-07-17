Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbZGQUTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbZGQUTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbZGQUTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:44 -0400
Received: from kroah.org ([198.145.64.141]:43093 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbZGQUTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:30 2009
Message-Id: <20090717201230.590698517@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:08:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Frysinger <vapier@gentoo.org>
Subject: [patch 08/24] Blackfin: fix command line corruption with DEBUG_DOUBLEFAULT
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=blackfin-fix-command-line-corruption-with-debug_doublefault.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 37082511f06108129bd5f96d625a6fae2d5a4ab4 upstream.

Commit 6b3087c6 (which introduced Blackfin SMP) broke command line passing
when the DEBUG_DOUBLEFAULT config option was enabled.  Switch the code to
using a scratch register and not R7 which holds the command line.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/blackfin/mach-common/head.S |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/blackfin/mach-common/head.S
+++ b/arch/blackfin/mach-common/head.S
@@ -126,25 +126,25 @@ ENTRY(__start)
 	 * below
 	 */
 	GET_PDA(p0, r0);
-	r7 = [p0 + PDA_RETX];
+	r6 = [p0 + PDA_RETX];
 	p1.l = _init_saved_retx;
 	p1.h = _init_saved_retx;
-	[p1] = r7;
+	[p1] = r6;
 
-	r7 = [p0 + PDA_DCPLB];
+	r6 = [p0 + PDA_DCPLB];
 	p1.l = _init_saved_dcplb_fault_addr;
 	p1.h = _init_saved_dcplb_fault_addr;
-	[p1] = r7;
+	[p1] = r6;
 
-	r7 = [p0 + PDA_ICPLB];
+	r6 = [p0 + PDA_ICPLB];
 	p1.l = _init_saved_icplb_fault_addr;
 	p1.h = _init_saved_icplb_fault_addr;
-	[p1] = r7;
+	[p1] = r6;
 
-	r7 = [p0 + PDA_SEQSTAT];
+	r6 = [p0 + PDA_SEQSTAT];
 	p1.l = _init_saved_seqstat;
 	p1.h = _init_saved_seqstat;
-	[p1] = r7;
+	[p1] = r6;
 #endif
 
 	/* Initialize stack pointer */


