Return-Path: <linux-kernel-owner+w=401wt.eu-S1763953AbYDPMto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763953AbYDPMto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763394AbYDPMsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:48:17 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47274 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1763402AbYDPMsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:48:16 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2008 08:48:14 EDT
Message-ID: <408349802.26451@ustc.edu.cn>
X-WebMAIL-MUA: [211.86.158.45]
From: "" <jszhang3@mail.ustc.edu.cn>
To: krh@redhat.com
Cc: stefanr@s5r6.in-berlin.de, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Date: Wed, 16 Apr 2008 20:43:22 +0800
Reply-To: "" <jszhang3@mail.ustc.edu.cn>
X-Priority: 3
Subject: [PATCH] firewire: fix sourceID read from wrong quadlet
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From JiSheng Zhang <jszhang3@mail.ustc.edu.cn>

In Asynchronous Receive Requests, the sourceID is in the second quadlet(OHCI 
specification, section 8.7.1).

--- linux-2.6.24.4/drivers/firewire/fw-transaction.c.orig    2008-04-14
20:57:48.294718721 +0800
+++ linux-2.6.24.4/drivers/firewire/fw-transaction.c    2008-04-14
20:58:07.083525930 +0800
@@ -650,7 +650,7 @@ fw_core_handle_request(struct fw_card *c
          HEADER_GET_OFFSET_HIGH(p->header[1]) << 32) | p->header[2];
     tcode       = HEADER_GET_TCODE(p->header[0]);
     destination = HEADER_GET_DESTINATION(p->header[0]);
-    source      = HEADER_GET_SOURCE(p->header[0]);
+    source      = HEADER_GET_SOURCE(p->header[1]);
 
     spin_lock_irqsave(&address_handler_lock, flags);
     handler = lookup_enclosing_address_handler(&address_handler_list,


