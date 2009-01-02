Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbZABIev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbZABIev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZABIdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:33:52 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:45398 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZABIdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:33:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=DicjVj54fwrrnRAUNnHhEFltpXjaUK0Y5FIhvhmbByANghCtyGXetoVHzq5N5+0jke
         usQQ7w1pZwMqa4ax0HAnfdV01TbyBwA4ZXQ3AircdHsTa59Ap7eeojZdDt0xKlD/zWfl
         ZL2Cx/bG9B/uut+P/Ga3pwM/ze5eBlCiyids0=
References: <20090102082717.810810508@gmail.com>>
User-Agent: quilt/0.46-1
Date: Fri, 02 Jan 2009 11:27:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Cc: gorcunov@gmail.com, Cyrill Gorcunov <gorcunov@openvz.org>,
       Len Brown <lenb@kernel.org>
Subject: [patch 3/3] acpi: check for pxm_to_node_map overflow
Content-Disposition: inline; filename=x86-acpi-pxm-overflow
Message-ID: <495dd169.0437560a.1cd3.ffffd503@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is hardly (if ever) possible but in case of broken _PXM
entry we could reach out of pxm_to_node_map array
bounds in acpi_map_pxm_to_node() call. Lets check it
(it's not that expensive and safe).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Len Brown <lenb@kernel.org>
---
 drivers/acpi/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/drivers/acpi/numa.c
===================================================================
--- linux-2.6.git.orig/drivers/acpi/numa.c
+++ linux-2.6.git/drivers/acpi/numa.c
@@ -278,7 +278,7 @@ int acpi_get_node(acpi_handle *handle)
 	int pxm, node = -1;
 
 	pxm = acpi_get_pxm(handle);
-	if (pxm >= 0)
+	if (pxm >= 0 && pxm < MAX_PXM_DOMAINS)
 		node = acpi_map_pxm_to_node(pxm);
 
 	return node;

-- 
