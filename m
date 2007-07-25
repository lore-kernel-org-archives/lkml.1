Return-Path: <linux-kernel-owner+w=401wt.eu-S1764593AbXGYHYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764593AbXGYHYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbXGYHYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:24:24 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:57753 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761894AbXGYHYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:24:23 -0400
Date: Wed, 25 Jul 2007 16:23:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] bsg: Fix build for CONFIG_BLOCK=n
Message-ID: <20070725072354.GA18706@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Jens Axboe <jens.axboe@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BLK_DEV_BSG was added outside of the if BLOCK check, which allows it to
be enabled when CONFIG_BLOCK=n. This leads to many screenlengths of
errors, starting with a parse error on the request_queue_t definition.
Obviously this wasn't intended for CONFIG_BLOCK=n usage, so just move the
option back in to the block.

Caught with a randconfig on sh.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 block/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index ca2ef4e..2484e0e 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -49,8 +49,6 @@ config LSF
 
 	  If unsure, say Y.
 
-endif # BLOCK
-
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -64,4 +62,6 @@ config BLK_DEV_BSG
 	protocols (e.g. Task Management Functions and SMP in Serial
 	Attached SCSI).
 
+endif # BLOCK
+
 source block/Kconfig.iosched
