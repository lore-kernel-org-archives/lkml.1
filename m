Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbZDHOAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbZDHOAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759040AbZDHOAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:00:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48600 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765525AbZDHOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:00:20 -0400
X-Sasl-enc: BT4XwKPO3kyjHGCCD+b6rd9xhLFnEuNdt3MO6MP4MbIz 1239199219
Message-ID: <49DCADF1.6030003@fastmail.fm>
Date: Wed, 08 Apr 2009 15:00:17 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 53/56] usb: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080511r5f02717h6fbf7bc63b7ffcf9@mail.gmail.com>
In-Reply-To: <36ca99e90904080511r5f02717h6fbf7bc63b7ffcf9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed patch

Thanks,

Jack

--

usb: Remove void casts

From: Jack Stone <jwjstone@fastmail.fm>

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---

 drivers/usb/host/ehci-dbg.c |    2 +-
 drivers/usb/host/ehci-mem.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 7f4ace7..abfc31f 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -832,7 +832,7 @@ static int fill_buffer(struct debug_buffer *buf)
     int ret = 0;
 
     if (!buf->output_buf)
-        buf->output_buf = (char *)vmalloc(buf->alloc_size);
+        buf->output_buf = vmalloc(buf->alloc_size);
 
     if (!buf->output_buf) {
         ret = -ENOMEM;
diff --git a/drivers/usb/host/ehci-mem.c b/drivers/usb/host/ehci-mem.c
index 10d5291..df5334f 100644
--- a/drivers/usb/host/ehci-mem.c
+++ b/drivers/usb/host/ehci-mem.c
@@ -83,8 +83,7 @@ static struct ehci_qh *ehci_qh_alloc (struct ehci_hcd
*ehci, gfp_t flags)
     struct ehci_qh        *qh;
     dma_addr_t        dma;
 
-    qh = (struct ehci_qh *)
-        dma_pool_alloc (ehci->qh_pool, flags, &dma);
+    qh = dma_pool_alloc (ehci->qh_pool, flags, &dma);
     if (!qh)
         return qh;
 
