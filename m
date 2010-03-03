Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0CCScO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:32:14 -0500
Received: from [206.15.93.42] ([206.15.93.42]:17848 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753271Ab0CCScM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:32:12 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/dt3155: fix build error caused by removing TRUE / FALSE defines
Date: Wed, 3 Mar 2010 11:32:11 -0700
Cc: greg@kroah.com, ss@aao.gov.au
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003031132.11925.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRUE and FALSE are also used in the wait_ibsyclr function. This will cause
a build error due to the patch that removes those defines.  Fix this by
returning proper error codes.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_io.c b/drivers/staging/dt3155/dt3155_io.c
index 6b9c685..38f343c 100644
--- a/drivers/staging/dt3155/dt3155_io.c
+++ b/drivers/staging/dt3155/dt3155_io.c
@@ -88,9 +88,9 @@ static int wait_ibsyclr(u8 *lpReg)
 		/* if NEW_CYCLE didn't clear */
 		/* TIMEOUT ERROR */
 		dt3155_errno = DT_ERR_I2C_TIMEOUT;
-		return FALSE;
+		return -ETIMEDOUT;
 	} else
-		return TRUE;	/* no error */
+		return 0;
 }
 
 /*
