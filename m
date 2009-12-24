Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZLXAzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZLXAzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 19:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZLXAy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 19:54:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36893 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZLXAy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 19:54:59 -0500
Date: Thu, 24 Dec 2009 11:54:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>
Subject: linux-next: origin tree build failure
Message-Id: <20091224115457.1db3541d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (powerpc allyesconfig) failed like this:

In file included from drivers/scsi/ibmvscsi/ibmvstgt.c:30:
include/scsi/libsrp.h:24: error: field 'queue' has incomplete type

Caused by commit 45465487897a1c6d508b14b904dc5777f7ec7e04 ("kfifo: move
struct kfifo in place").

I added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 24 Dec 2009 11:44:28 +1100
Subject: [PATCH] kfifo: include linux/fifo.h in libsrp.h for definition of stuct kfifo

This fixes this compiler error:

In file included from drivers/scsi/ibmvscsi/ibmvstgt.c:30:
include/scsi/libsrp.h:24: error: field 'queue' has incomplete type

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/scsi/libsrp.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
-- 
1.6.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
