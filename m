Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbXJQW7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbXJQW7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759797AbXJQW73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:59:29 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49092 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbXJQW71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:59:27 -0400
Subject: [PATCH] ip_gra_reasm() should set "err" incase of skb_clone()
	failure
From: Badari Pulavarty <pbadari@us.ibm.com>
To: netdev@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 16:02:33 -0700
Message-Id: <1192662154.14504.7.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simple error handling fix (against 2.26.23-git12).

Thanks,
Badari

Need to initialize "err" in case of skb_clone() failure.

net/ipv4/ip_fragment.c: In function `ip_defrag':
net/ipv4/ip_fragment.c:540: warning: `err' might be used uninitialized in this function

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 net/ipv4/ip_fragment.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.23/net/ipv4/ip_fragment.c
===================================================================
--- linux-2.6.23.orig/net/ipv4/ip_fragment.c	2007-10-17 15:33:27.000000000 -0700
+++ linux-2.6.23/net/ipv4/ip_fragment.c	2007-10-17 15:50:51.000000000 -0700
@@ -544,6 +544,7 @@ static int ip_frag_reasm(struct ipq *qp,
 	/* Make the one we just received the head. */
 	if (prev) {
 		head = prev->next;
+		err = -ENOMEM;
 		fp = skb_clone(head, GFP_ATOMIC);
 
 		if (!fp)



