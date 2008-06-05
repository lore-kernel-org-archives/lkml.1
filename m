Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYFEKeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYFEKeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbYFEKdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 06:33:50 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:1734 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754433AbYFEKdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 06:33:49 -0400
Subject: [PATCH] Net: reorder udp_iter_state to remove padding on 64bit
	builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 11:33:39 +0100
Message-Id: <1212662019.3039.14.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder udp_iter_state to remove padding on 64bit builds

shrinks from 24 to 16 bytes, moving to a smaller slab when CONFIG_NET_NS
is undefined & seq_net_private = {}

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
static analysis found this padding in udp_iter_state.

I've boot tested 2.6.26-rc4 + patch on desktop AMD64, and successfully
run a simple UDP test case.

Richard



diff --git a/include/net/udp.h b/include/net/udp.h
index ccce837..7a86848 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -196,8 +196,8 @@ struct udp_seq_afinfo {
 struct udp_iter_state {
 	struct seq_net_private  p;
 	sa_family_t		family;
-	struct hlist_head	*hashtable;
 	int			bucket;
+	struct hlist_head	*hashtable;
 };
 
 #ifdef CONFIG_PROC_FS


