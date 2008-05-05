Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbYEES3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbYEES3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760587AbYEES0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:26:42 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54969 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760581AbYEES0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:26:41 -0400
Date: Mon, 5 May 2008 21:25:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sebastian Siewior <bigeasy@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] usb/host/isp1760-hcd.c: make 2 functions static
Message-ID: <20080505182533.GQ17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- enqueue_an_ATL_packet()
- enqueue_an_INT_packet()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/usb/host/isp1760-hcd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

2dfaa1d7b4c983c1cce00d65f983f6a5d2c09ae3 diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 4ba96c1..bf02da7 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -782,8 +782,8 @@ static void enqueue_one_int_qtd(u32 int_regs, u32 payload,
 	qtd->status |= slot << 16;
 }
 
-void enqueue_an_ATL_packet(struct usb_hcd *hcd, struct isp1760_qh *qh,
-		struct isp1760_qtd *qtd)
+static void enqueue_an_ATL_packet(struct usb_hcd *hcd, struct isp1760_qh *qh,
+				  struct isp1760_qtd *qtd)
 {
 	struct isp1760_hcd *priv = hcd_to_priv(hcd);
 	u32 skip_map, or_map;
@@ -816,8 +816,8 @@ void enqueue_an_ATL_packet(struct usb_hcd *hcd, struct isp1760_qh *qh,
 	isp1760_writel(buffstatus, hcd->regs + HC_BUFFER_STATUS_REG);
 }
 
-void enqueue_an_INT_packet(struct usb_hcd *hcd, struct isp1760_qh *qh,
-		struct isp1760_qtd *qtd)
+static void enqueue_an_INT_packet(struct usb_hcd *hcd, struct isp1760_qh *qh,
+				  struct isp1760_qtd *qtd)
 {
 	struct isp1760_hcd *priv = hcd_to_priv(hcd);
 	u32 skip_map, or_map;

