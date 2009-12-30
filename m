Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZL3TVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZL3TVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZL3TVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:21:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbZL3TVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:21:37 -0500
Subject: [PATCH] libsrp: fix compile failure
From: James Bottomley <James.Bottomley@suse.de>
To: Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 13:21:06 -0600
Message-Id: <1262200866.2749.226.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 45465487897a1c6d508b14b904dc5777f7ec7e04
Author: Stefani Seibold <stefani@seibold.net>
Date:   Mon Dec 21 14:37:26 2009 -0800

    kfifo: move struct kfifo in place

Caused a compile failure in ibmvscsitgt.c because it changed a pointer
to kfifo in the libsrp.h structure to a direct inclusion without
including <linux/kfifo.h>.  The fix is simple, just add the include, but
how did this happen?  This change, introduced at -rc2, hardly looks like
a bug fix, and it clearly didn't go through linux-next, which would have
picked up this compile failure (it only occurs on ppc because of the ibm
virtual scsi target).

James

---

diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
index 07e3add..f4105c9 100644
--- a/include/scsi/libsrp.h
+++ b/include/scsi/libsrp.h
@@ -2,6 +2,7 @@
 #define __LIBSRP_H__
 
 #include <linux/list.h>
+#include <linux/kfifo.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <scsi/srp.h>


