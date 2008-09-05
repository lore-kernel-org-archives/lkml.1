Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYIETbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYIETbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYIETbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:31:08 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:2815 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYIETbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v6Wjo1604xPUBJlGOOs5roP6pkRkFCB9Lix2PBw1KkzScuOngbC3xmX3qvAdljsrYq
         MoinxLuArwAEMPkEvOWlqYeC5gwey9K8sKgdJdUE7qvozNtoJVc6zP0upxKZuYM7qCxk
         RxHPn8UcQCUNDIWZvivKB7l6oJnKeknu9mUC4=
Date: Fri, 5 Sep 2008 23:32:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com,
       netdev@vger.kernel.org
Subject: [PATCH -mm] Fix dev_load() compilation again
Message-ID: <20080905193244.GD11569@x200.localdomain>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904224004.d3dd3076.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_load() doesn't exist if MODULES=n.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/netdevice.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1639,7 +1639,13 @@ extern int		dev_set_allmulti(struct net_device *dev, int inc);
 extern void		netdev_state_change(struct net_device *dev);
 extern void		netdev_bonding_change(struct net_device *dev);
 extern void		netdev_features_change(struct net_device *dev);
+#ifdef CONFIG_MODULES
 extern void		dev_load(struct net *net, const char *name);
+#else
+static inline void dev_load(struct net *net, const char *name)
+{
+}
+#endif
 extern void		dev_mcast_init(void);
 extern int		netdev_max_backlog;
 extern int		weight_p;

