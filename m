Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbZAMBbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbZAMBbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbZAMB27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:28:59 -0500
Received: from kroah.org ([198.145.64.141]:35935 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757043AbZAMB25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:28:57 -0500
Date: Mon, 12 Jan 2009 17:26:58 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Guillaume Knispel <gknispel@proformatique.com>,
       Timur Tabi <timur@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: [patch 05/21] powerpc: Fix corruption error in rh_alloc_fixed()
Message-ID: <20090113012658.GF4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-fix-corruption-error-in-rh_alloc_fixed.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guillaume Knispel <gknispel@proformatique.com>

commit af4d3643864ee5fcba0c97d77a424fa0b0346f8e upstream.

There is an error in rh_alloc_fixed() of the Remote Heap code:
If there is at least one free block blk won't be NULL at the end of the
search loop, so -ENOMEM won't be returned and the else branch of
"if (bs == s || be == e)" will be taken, corrupting the management
structures.

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
Acked-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/lib/rheap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/lib/rheap.c
+++ b/arch/powerpc/lib/rheap.c
@@ -556,6 +556,7 @@ unsigned long rh_alloc_fixed(rh_info_t *
 		be = blk->start + blk->size;
 		if (s >= bs && e <= be)
 			break;
+		blk = NULL;
 	}
 
 	if (blk == NULL)

