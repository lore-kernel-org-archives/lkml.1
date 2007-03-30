Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbXC3VLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbXC3VLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXC3VLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:11:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51656 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXC3VLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:11:49 -0400
Date: Fri, 30 Mar 2007 14:06:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michael Hunold <hunold@linuxtv.org>,
       Oliver Endriss <o.endriss@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 26/37] V4L: saa7146: Fix allocation of clipping memory
Message-ID: <20070330210630.GC29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-saa7146-fix-allocation-of-clipping-memory.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oliver Endriss <o.endriss@gmx.de>

V4L: saa7146: Fix allocation of clipping memory

Olaf Hering pointed out that SAA7146_CLIPPING_MEM would become
very large for PAGE_SIZE > 4K.

In fact, the number of clipping windows is limited to 16,
and calculate_clipping_registers_rect() does not use more
than 256 bytes. SAA7146_CLIPPING_MEM adjusted accordingly.

(cherry picked from commit 7a7cd1920969dd9da4e0d99aab573b3eba24c799)

Thanks-to: Olaf Hering <olaf@aepfle.de>
Acked-by: Michael Hunold <hunold@linuxtv.org>
Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/media/saa7146_vv.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -239,7 +239,8 @@ void saa7146_res_free(struct saa7146_fh 
 #define SAA7146_HPS_SYNC_PORT_B		0x01
 
 /* some memory sizes */
-#define SAA7146_CLIPPING_MEM	(14*PAGE_SIZE)
+/* max. 16 clipping rectangles */
+#define SAA7146_CLIPPING_MEM	(16 * 4 * sizeof(u32))
 
 /* some defines for the various clipping-modes */
 #define SAA7146_CLIPPING_RECT		0x4

-- 
