Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXJNFf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXJNFf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXJNFfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:35:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50413 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188AbXJNFfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:35:11 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@linux.intel.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Sat, 13 Oct 2007 22:35:08 -0700
Message-Id: <20071014053508.30836.69658.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] git scsi misc include fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

The added line in scsi_eh.h:
	struct scatterlist sense_sgl;
fails to compile, with the error:
	field 'sense_sgl' has incomplete type
unless scatterlist.h happens to be included
somehow already ... which it isn't always.

So include scatterlist.h in scsi_eh.h directly.

Signed-off-by: Paul Jackson <pj@sgi.com>

---

This patch goes after the patch 'git-scsi-misc.patch'

 include/scsi/scsi_eh.h |    1 +
 1 file changed, 1 insertion(+)

--- 2.6.23-mm1.orig/include/scsi/scsi_eh.h	2007-10-13 01:13:26.568876534 -0700
+++ 2.6.23-mm1/include/scsi/scsi_eh.h	2007-10-13 01:31:32.911855338 -0700
@@ -2,6 +2,7 @@
 #define _SCSI_SCSI_EH_H
 
 #include <scsi/scsi_cmnd.h>
+#include <linux/scatterlist.h>
 struct scsi_device;
 struct Scsi_Host;
 

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
