Return-Path: <linux-kernel-owner+w=401wt.eu-S934375AbXKPCfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375AbXKPCfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934055AbXKPCes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:34:48 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35241 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768AbXKPCer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:34:47 -0500
Message-Id: <473D0163.5070602@mxs.nes.nec.co.jp>
Date: Fri, 16 Nov 2007 11:33:07 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH 2/5] Use the existing offsetof() for VMCOREINFO_OFFSET()
References: <473CFE14.3010400@mxs.nes.nec.co.jp>
In-Reply-To: <473CFE14.3010400@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It is better that the existing offsetof() is used for VMCOREINFO_OFFSET().

This discussion is the following:
http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0584.html

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
---
diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
--- a/include/linux/kexec.h	2007-11-12 11:03:31.000000000 +0900
+++ b/include/linux/kexec.h	2007-11-12 11:03:43.000000000 +0900
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

