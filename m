Return-Path: <linux-kernel-owner+w=401wt.eu-S2993052AbXCIH26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993052AbXCIH26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993058AbXCIH26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:28:58 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:8323 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993052AbXCIH25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:28:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=CN5qqy0u9hTUcMaMIwRBIwCYFJBu6Dk0nx1OcddTIZjGHmu7R7opxb8QNze5Vjbq6CPk4ZiWHn78Qynve4QmvlfsVlRsXjvSdnunNcpdvw77zyUaKeIe+Mtip+3enS2qF3v6JxUT/2CwwCNB3TYpqxnfXYYnfkhh+8VawiWqlno=
Date: Thu, 8 Mar 2007 23:28:43 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/char/agp/sgi-agp.c: check kmalloc() return value.
Message-Id: <20070308232843.864d797a.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function agp_sgi_init(), in file drivers/char/agp/sgi-agp.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index d73be4c..5897e6c 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -285,6 +285,8 @@ static int __devinit agp_sgi_init(void)
 	    (struct agp_bridge_data **)kmalloc(tioca_gart_found *
 					       sizeof(struct agp_bridge_data *),
 					       GFP_KERNEL);
+	if (!sgi_tioca_agp_bridges)
+		return -ENOMEM;
 
 	j = 0;
 	list_for_each_entry(info, &tioca_list, ca_list) {
