Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYGVVlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYGVVlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYGVVkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:40:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:13032 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYGVVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Kbr9n7zo3nSH2xHBYxasNLNhx0YKTqXNtE/UlOaWuEcJeFhHvEwvz4bIIEKMCc8jA+
         /HALljVoKAQf0alHijdEvAZ+LnQXYvaXLqe5PjvkP5/sjAzOXu3wiNn0EPxkLrAHTh76
         NgdURUZNcnwv4NNKGD9DY/sqriOIqQFz8wfMc=
Subject: [PATCH] pci: proc.c sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200807221437.01847.jesse.barnes@intel.com>
References: <1216335450.6029.45.camel@brick>
	 <200807221437.01847.jesse.barnes@intel.com>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 14:40:47 -0700
Message-Id: <1216762847.13328.19.camel@brick>
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



