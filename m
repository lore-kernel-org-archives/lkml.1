Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063Ab0AGXgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0AGXgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419Ab0AGXgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:36:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab0AGXgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:36:13 -0500
Date: Thu, 7 Jan 2010 18:35:58 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Scott Davilla <davilla@4pi.com>
Subject: [PATCH] staging: crystalhd: add missing fixes for userspace lib build
Message-ID: <20100107233558.GA23261@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I somehow managed to not actually include these two fixes in the submission
that was committed to the staging tree. libcrystalhd should eventually be
built against the kernel-provided header, and needs the stdint.h include. The
VOID bit is to keep things in sync with the Mac OS X driver and library that
Scott Davilla is also working on.

Signed-off-by: Scott Davilla <davilla@4pi.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/staging/crystalhd/bc_dts_types.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/crystalhd/bc_dts_types.h b/drivers/staging/crystalhd/bc_dts_types.h
index e073d74..ac0c817 100644
--- a/drivers/staging/crystalhd/bc_dts_types.h
+++ b/drivers/staging/crystalhd/bc_dts_types.h
@@ -25,6 +25,10 @@
 #ifndef _BC_DTS_TYPES_H_
 #define _BC_DTS_TYPES_H_
 
+#ifdef __LINUX_USER__  // Don't include these for KERNEL..
+#include <stdint.h>
+#endif
+
 #if defined(_WIN64) || defined(_WIN32)
 typedef uint32_t		U32;
 typedef int32_t			S32;
@@ -62,7 +66,9 @@ typedef int	BOOL;
 typedef uint32_t	ULONG;
 typedef int32_t		LONG;
 typedef void		*HANDLE;
+#ifndef VOID
 typedef void		VOID;
+#endif
 typedef void		*LPVOID;
 typedef uint32_t	DWORD;
 typedef uint32_t	UINT32;

-- 
Jarod Wilson
jarod@redhat.com

