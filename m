Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbXKPVKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbXKPVKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbXKPVKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:10:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:61102 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbXKPVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:10:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jjUjhpsZT6jYJJMAAJM7tbaD/5oHwTrkT3VpmYk5bfJmyTAaiyalUwFO+6jsRzedrZuduJmP+8YmbJL7JguQBNHwoirxOvjYkNYWDTU0Tf/L1Ek4gMJTXru2Pal2H99Fen9fB7XaVItwRhlsg1Rzzbo9QrTh2QczK60uQfPXGIU=
Date: Sat, 17 Nov 2007 00:10:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] PPC: add for_each_node_child() macro
Message-ID: <20071116211002.GC7710@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds usefull macro to iterate over a node childs.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
TODO: convert all for(...) cycles to this macro.

 include/linux/of.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 5c39b92..a93e2aa 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -46,6 +46,8 @@ extern struct device_node *of_find_node_by_phandle(phandle handle);
 extern struct device_node *of_get_parent(const struct device_node *node);
 extern struct device_node *of_get_next_child(const struct device_node *node,
 					     struct device_node *prev);
+#define for_each_node_child(dn, child) \
+	for (child = NULL; (child = of_get_next_child(dn, child)); )
 extern struct property *of_find_property(const struct device_node *np,
 					 const char *name,
					 int *lenp);

