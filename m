Return-Path: <linux-kernel-owner+w=401wt.eu-S1423055AbXEDXt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423055AbXEDXt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423049AbXEDXoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:44:06 -0400
Received: from 116.sub-75-210-58.myvzw.com ([75.210.58.116]:46308 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423061AbXEDXne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:43:34 -0400
Message-Id: <20070504232121.366607336@goop.org>
References: <20070504232051.411946839@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 May 2007 16:21:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 24/29] xen: rename xen netif_ structures to xen_netif_
Content-Disposition: inline; filename=xen-netif-rename.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The "netif_" prefix is used in the Linux network stack, so rename the
Xen structures to xen_netif_ to avoid confusion (and potential
collision).

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 include/xen/interface/io/netif.h |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

===================================================================
--- a/include/xen/interface/io/netif.h
+++ b/include/xen/interface/io/netif.h
@@ -47,7 +47,7 @@
 #define _NETTXF_extra_info     (3)
 #define  NETTXF_extra_info     (1U<<_NETTXF_extra_info)
 
-struct netif_tx_request {
+struct xen_netif_tx_request {
     grant_ref_t gref;      /* Reference to buffer page */
     uint16_t offset;       /* Offset within buffer page */
     uint16_t flags;        /* NETTXF_* */
@@ -71,7 +71,7 @@ struct netif_tx_request {
  * This structure needs to fit within both netif_tx_request and
  * netif_rx_response for compatibility.
  */
-struct netif_extra_info {
+struct xen_netif_extra_info {
     uint8_t type;  /* XEN_NETIF_EXTRA_TYPE_* */
     uint8_t flags; /* XEN_NETIF_EXTRA_FLAG_* */
 
@@ -103,12 +103,12 @@ struct netif_extra_info {
     } u;
 };
 
-struct netif_tx_response {
+struct xen_netif_tx_response {
     uint16_t id;
     int16_t  status;       /* NETIF_RSP_* */
 };
 
-struct netif_rx_request {
+struct xen_netif_rx_request {
     uint16_t    id;        /* Echoed in response message.        */
     grant_ref_t gref;      /* Reference to incoming granted frame */
 };
@@ -129,7 +129,7 @@ struct netif_rx_request {
 #define _NETRXF_extra_info     (3)
 #define  NETRXF_extra_info     (1U<<_NETRXF_extra_info)
 
-struct netif_rx_response {
+struct xen_netif_rx_response {
     uint16_t id;
     uint16_t offset;       /* Offset in page of start of received packet  */
     uint16_t flags;        /* NETRXF_* */
@@ -140,8 +140,12 @@ struct netif_rx_response {
  * Generate netif ring structures and types.
  */
 
-DEFINE_RING_TYPES(netif_tx, struct netif_tx_request, struct netif_tx_response);
-DEFINE_RING_TYPES(netif_rx, struct netif_rx_request, struct netif_rx_response);
+DEFINE_RING_TYPES(xen_netif_tx,
+		  struct xen_netif_tx_request,
+		  struct xen_netif_tx_response);
+DEFINE_RING_TYPES(xen_netif_rx,
+		  struct xen_netif_rx_request,
+		  struct xen_netif_rx_response);
 
 #define NETIF_RSP_DROPPED         -2
 #define NETIF_RSP_ERROR           -1

-- 

