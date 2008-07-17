Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbYGQW5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbYGQW5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYGQW5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:57:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:10420 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYGQW5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=TJ2svjnZzvcczfNC3JzmKOqCYnq1PmsnMG0TZGWDJ+mKvtnSRriIyYKjbCdvALQY/p
         xsZHd57E5MQ9J1oiaK3ClfZFXXrABbnJ5UjzZL2JeWG5D+FvL9Mbisryj99YZsEfFpj7
         RlPRLjhdLFsyr9ZUgpgTA2yZJztcQUHsYDeqI=
Subject: [PATCH] pci: proc.c sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 15:57:30 -0700
Message-Id: <1216335450.6029.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pci/proc.c:91:3: warning: cast from restricted __le16
drivers/pci/proc.c:100:3: warning: cast from restricted __le32
drivers/pci/proc.c:109:3: warning: cast from restricted __le16
drivers/pci/proc.c:161:40: warning: cast to restricted __le16
drivers/pci/proc.c:170:41: warning: cast to restricted __le32
drivers/pci/proc.c:179:40: warning: cast to restricted __le16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Patch against next-20080717

 drivers/pci/proc.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 7e2bd7e..c8eb11c 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -88,7 +88,7 @@ proc_bus_pci_read(struct file *file, char __user *buf, size_t nbytes, loff_t *pp
 	if ((pos & 3) && cnt > 2) {
 		unsigned short val;
 		pci_user_read_config_word(dev, pos, &val);
-		__put_user(cpu_to_le16(val), (unsigned short __user *) buf);
+		__put_user(cpu_to_le16(val), (__le16 __user *) buf);
 		buf += 2;
 		pos += 2;
 		cnt -= 2;
@@ -97,7 +97,7 @@ proc_bus_pci_read(struct file *file, char __user *buf, size_t nbytes, loff_t *pp
 	while (cnt >= 4) {
 		unsigned int val;
 		pci_user_read_config_dword(dev, pos, &val);
-		__put_user(cpu_to_le32(val), (unsigned int __user *) buf);
+		__put_user(cpu_to_le32(val), (__le32 __user *) buf);
 		buf += 4;
 		pos += 4;
 		cnt -= 4;
@@ -106,7 +106,7 @@ proc_bus_pci_read(struct file *file, char __user *buf, size_t nbytes, loff_t *pp
 	if (cnt >= 2) {
 		unsigned short val;
 		pci_user_read_config_word(dev, pos, &val);
-		__put_user(cpu_to_le16(val), (unsigned short __user *) buf);
+		__put_user(cpu_to_le16(val), (__le16 __user *) buf);
 		buf += 2;
 		pos += 2;
 		cnt -= 2;
@@ -156,8 +156,8 @@ proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, lof
 	}
 
 	if ((pos & 3) && cnt > 2) {
-		unsigned short val;
-		__get_user(val, (unsigned short __user *) buf);
+		__le16 val;
+		__get_user(val, (__le16 __user *) buf);
 		pci_user_write_config_word(dev, pos, le16_to_cpu(val));
 		buf += 2;
 		pos += 2;
@@ -165,8 +165,8 @@ proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, lof
 	}
 
 	while (cnt >= 4) {
-		unsigned int val;
-		__get_user(val, (unsigned int __user *) buf);
+		__le32 val;
+		__get_user(val, (__le32 __user *) buf);
 		pci_user_write_config_dword(dev, pos, le32_to_cpu(val));
 		buf += 4;
 		pos += 4;
@@ -174,8 +174,8 @@ proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, lof
 	}
 
 	if (cnt >= 2) {
-		unsigned short val;
-		__get_user(val, (unsigned short __user *) buf);
+		__le16 val;
+		__get_user(val, (__le16 __user *) buf);
 		pci_user_write_config_word(dev, pos, le16_to_cpu(val));
 		buf += 2;
 		pos += 2;
-- 
1.5.6.3.569.ga9185



