Return-Path: <linux-kernel-owner+w=401wt.eu-S1764957AbXINC4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764957AbXINC4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 22:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbXINC4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 22:56:30 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62764 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbXINC43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 22:56:29 -0400
Message-Id: <46E9F854.9030804@mxs.nes.nec.co.jp>
Date: Fri, 14 Sep 2007 11:56:20 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] [-mm patch]  Add nodemask_t's size and NR_FREE_PAGES's
 value to vmcoreinfo_data.
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp>
In-Reply-To: <46E9F6A9.8060500@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[2/4] Add nodemask_t's size and NR_FREE_PAGES's value to vmcoreinfo_data.
   The dump filetering command 'makedumpfile'(v1.1.6 or before) had assumed
   the above values, and it was not good from the reliability viewpoint.
   So makedumpfile v1.2.0 came to need these values and I created the patch
   to let the kernel output them.
   makedumpfile site:
   https://sourceforge.net/projects/makedumpfile/


Thanks
Ken'ichi Ohmichi

---
Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

---
diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
--- a/include/linux/kexec.h	2007-09-10 23:28:42.000000000 +0900
+++ b/include/linux/kexec.h	2007-09-10 23:29:52.000000000 +0900
@@ -132,11 +132,16 @@ unsigned long paddr_vmcoreinfo_note(void
  #define SIZE(name) \
  	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
  			      (unsigned long)sizeof(struct name))
+#define TYPEDEF_SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
+			      (unsigned long)sizeof(name))
  #define OFFSET(name, field) \
  	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
  			      (unsigned long)&(((struct name *)0)->field))
  #define LENGTH(name, value) \
  	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
+#define NUMBER(name) \
+	vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
  #define CONFIG(name) \
  	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)

diff -rpuN a/kernel/kexec.c b/kernel/kexec.c
--- a/kernel/kexec.c	2007-09-10 23:28:42.000000000 +0900
+++ b/kernel/kexec.c	2007-09-10 23:29:02.000000000 +0900
@@ -1218,6 +1218,7 @@ static int __init crash_save_vmcoreinfo_
  	SIZE(zone);
  	SIZE(free_area);
  	SIZE(list_head);
+	TYPEDEF_SIZE(nodemask_t);
  	OFFSET(page, flags);
  	OFFSET(page, _count);
  	OFFSET(page, mapping);
@@ -1237,6 +1238,7 @@ static int __init crash_save_vmcoreinfo_
  	OFFSET(list_head, next);
  	OFFSET(list_head, prev);
  	LENGTH(zone.free_area, MAX_ORDER);
+	NUMBER(NR_FREE_PAGES);

  	arch_crash_save_vmcoreinfo();

_

