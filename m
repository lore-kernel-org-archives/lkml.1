Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbXITFdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbXITFdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbXITFc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:32:56 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:55191 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbXITFcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:32:54 -0400
Message-Id: <46F205DB.70209@mxs.nes.nec.co.jp>
Date: Thu, 20 Sep 2007 14:32:11 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>
Subject: [PATCH 6/4] [-mm patch] use the existing offsetof().
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp>	<46E9F942.5070007@mxs.nes.nec.co.jp> <20070914190350.011cdadb.akpm@linux-foundation.org> <46F204FD.6040303@mxs.nes.nec.co.jp>
In-Reply-To: <46F204FD.6040303@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 6/4] [-mm patch] use the existing offsetof().
 It is better that offsetof() is used for VMCOREINFO_OFFSET().
 This idea is Joe Perches's.



Thanks
Ken'ichi Ohmichi 

---
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
---
diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
--- a/include/linux/kexec.h	2007-09-18 15:23:22.000000000 +0900
+++ b/include/linux/kexec.h	2007-09-18 15:27:29.000000000 +0900
@@ -137,7 +137,7 @@ unsigned long paddr_vmcoreinfo_note(void
 			      (unsigned long)sizeof(struct name))
 #define VMCOREINFO_OFFSET(name, field) \
 	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
-			      (unsigned long)&(((struct name *)0)->field))
+			      (unsigned long)offsetof(struct name, field))
 #define VMCOREINFO_LENGTH(name, value) \
 	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
 #define VMCOREINFO_NUMBER(name) \
_

