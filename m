Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584Ab0ASVB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0ASVB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129Ab0ASVB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:01:26 -0500
Received: from [206.15.93.42] ([206.15.93.42]:9309 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753657Ab0ASVB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:01:26 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysctl_binary.c: use skip_spaces to strip leading whitespace
Date: Tue, 19 Jan 2010 14:01:28 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001191401.28995.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the library function instead of a while loop.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 8f5d16e..0220e35 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1001,8 +1001,7 @@ static ssize_t bin_intvec(struct file *file,
 			unsigned long value;
 
 			value = simple_strtoul(str, &str, 10);
-			while (isspace(*str))
-				str++;
+			str = skip_spaces(str);
 			
 			result = -EFAULT;
 			if (put_user(value, vec + i))
@@ -1079,8 +1078,7 @@ static ssize_t bin_ulongvec(struct file *file,
 			unsigned long value;
 
 			value = simple_strtoul(str, &str, 10);
-			while (isspace(*str))
-				str++;
+			str = skip_spaces(str);
 			
 			result = -EFAULT;
 			if (put_user(value, vec + i))
