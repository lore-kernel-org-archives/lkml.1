Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbZFIKZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbZFIKZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760642AbZFIKT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:29 -0400
Received: from kroah.org ([198.145.64.141]:54830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760678AbZFIKT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:19:28 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:00 2009
Message-Id: <20090609094100.715289290@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Korsgaard <jacmet@sunsite.dk>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 37/87] mtd_dataflash: unbreak erase support
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=mtd_dataflash-unbreak-erase-support.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit dbf8c11f821b6ff83302c34f2403b4f7231f50ae upstream.

Commit 5b7f3a50 (fix dataflash 64-bit divisions) unfortunately
introduced a typo. Erase addr and len were swapped in the pageaddr
calculation, causing the wrong sectors to get erased.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/devices/mtd_dataflash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -184,7 +184,7 @@ static int dataflash_erase(struct mtd_in
 		/* Calculate flash page address; use block erase (for speed) if
 		 * we're at a block boundary and need to erase the whole block.
 		 */
-		pageaddr = div_u64(instr->len, priv->page_size);
+		pageaddr = div_u64(instr->addr, priv->page_size);
 		do_block = (pageaddr & 0x7) == 0 && instr->len >= blocksize;
 		pageaddr = pageaddr << priv->page_offset;
 


