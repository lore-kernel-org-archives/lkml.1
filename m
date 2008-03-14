Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYCNT7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYCNT7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYCNT66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:58:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:61386 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYCNT65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:58:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F454oEq45BGzMBQh8gnnjvPP9bPiUPM8bq7+oqQy6lG5aZj6iidmPR9dUnX3tGkSzG9A4nXIu1wjLmzDuG2JkRPzvmIaWYtT/R2SSEm/jDoMa50oWNfJwKZMWiSHtW+nL8hLjYcmTZq4rm6obxlTDaM24jT59bEhvET3d/G0h/c=
Subject: [PATCH] add kerneldoc for clamp(), clamp_t(), clamp_val() macros
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 12:58:49 -0700
Message-Id: <1205524734.27712.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/kernel.h |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c74460c..d57e537 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -351,6 +351,15 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+/**
+ * clamp - return a value clamped to a given range with strict typechecking
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does strict typechecking of min/max to make sure they are of the
+ * same type as val.  See the unnecessary pointer comparisons.
+ */
 #define clamp(val, min, max) ({			\
 	typeof(val) __val = (val);		\
 	typeof(min) __min = (min);		\
@@ -376,6 +385,16 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
 	type __max2 = (y);			\
 	__max1 > __max2 ? __max1: __max2; })
 
+/**
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * 'type' to make all the comparisons.
+ */
 #define clamp_t(type, val, min, max) ({		\
 	type __val = (val);			\
 	type __min = (min);			\
@@ -383,6 +402,17 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
 	__val = __val < __min ? __min: __val;	\
 	__val > __max ? __max: __val; })
 
+/**
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument 'val' is.  This is useful when val is an unsigned
+ * type and min and max are literals that will otherwise be assigned a signed
+ * integer type.
+ */
 #define clamp_val(val, min, max) ({		\
 	typeof(val) __val = (val);		\
 	typeof(val) __min = (min);		\
-- 
1.5.4.4.684.g0e08



