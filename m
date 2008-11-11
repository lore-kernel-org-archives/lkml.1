Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYKKBBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYKKBBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYKKBBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:01:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33760 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbYKKBBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:01:36 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do division with
	rounding
To: "Darrick J. Wong" <djwong@us.ibm.com>, Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Date: Mon, 10 Nov 2008 17:01:32 -0800
Message-ID: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Create a helper macro to divide two numbers and round the result to the
nearest whole number.  This is a helper macro for hwmon drivers that
want to convert incoming sysfs values per standard hwmon practice, though
the macro itself can be used by anyone.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 include/linux/kernel.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fba141d..fb02266 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -48,6 +48,12 @@ extern const char linux_proc_banner[];
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+#define DIV_ROUND_CLOSEST(x, divisor)(			\
+{							\
+	typeof(divisor) __divisor = divisor;		\
+	(((x) + ((__divisor) / 2)) / (__divisor));	\
+}							\
+)
 
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })

