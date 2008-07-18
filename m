Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYGRJGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYGRJGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYGRJG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:06:26 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60166 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754120AbYGRJGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:06:25 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 05:06:24 EDT
Message-ID: <416371533.19965@ustc.edu.cn>
X-WebMAIL-MUA: [211.86.158.24]
From: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
To: stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Date: Fri, 18 Jul 2008 16:58:53 +0800
Reply-To: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
X-Priority: 3
Subject: PATCH] firewire: add padding to some struct
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From JiSheng Zhang <jszhang3@mail.ustc.edu.cn>

struct fw_cdev_event_response and struct fw_cdev_event_iso_interrupt need padding.
Otherwise, offset of the zero length array is not equal to the struct size. It may
cause some strange problems under some platforms such as sparc32. This
patch(against 2.6.26) should fix it.


--- old/include/linux/firewire-cdev.h	2008-07-18 16:34:01.181794046 +0800
+++ new/include/linux/firewire-cdev.h	2008-07-18 16:35:46.649294275 +0800
@@ -92,6 +92,7 @@
 	__u32 type;
 	__u32 rcode;
 	__u32 length;
+	__u32 pad;
 	__u32 data[0];
 };
 
@@ -143,6 +144,7 @@
 	__u32 type;
 	__u32 cycle;
 	__u32 header_length;
+	__u32 pad;
 	__u32 header[0];
 };
 


