Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbYBZXex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbYBZXex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYBZXen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:34:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:44033 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYBZXem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:34:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=J/ZMVLF1y+RCruZF/q91Z3vxiLmn11WUUv1YauhWxKbMKzaAdw3QoA339gVmNx39MFDbKk17kK5x/tneCEGNwlFUU8eB2E8vRylsDLFNhgJD3TAK1FaEyvDGtkohiIF3lkM++8dWBjXZiZJa6VbruWyn3FCGw6nhZIj3lX+u4a8=
Date: Wed, 27 Feb 2008 01:31:48 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-security-module@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm 4/4] Netlink: Use LSM interface instead of SELinux one
Message-ID: <20080226233148.GE12059@ubuntu>
References: <20080226232229.GA12059@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226232229.GA12059@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use SELinux exported selinux_get_task_sid symbol. 
Use the generic LSM equivalent instead.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1ab0da2..61fd277 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -54,7 +54,6 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <linux/audit.h>
-#include <linux/selinux.h>
 #include <linux/mutex.h>
 
 #include <net/net_namespace.h>
@@ -1239,7 +1238,7 @@ static int netlink_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	NETLINK_CB(skb).pid	= nlk->pid;
 	NETLINK_CB(skb).dst_group = dst_group;
 	NETLINK_CB(skb).loginuid = audit_get_loginuid(current);
-	selinux_get_task_sid(current, &(NETLINK_CB(skb).sid));
+	security_task_getsecid(current, &(NETLINK_CB(skb).sid));
 	memcpy(NETLINK_CREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
 
 	/* What can I do? Netlink is asynchronous, so that

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

