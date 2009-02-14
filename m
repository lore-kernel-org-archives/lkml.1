Return-Path: <linux-kernel-owner+w=401wt.eu-S1762924AbZBNBIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762924AbZBNBIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760838AbZBNBBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:45 -0500
Received: from kroah.org ([198.145.64.141]:39627 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757885AbZBNBBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:42 -0500
Date: Fri, 13 Feb 2009 16:58:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Benjamin Zores <benjamin.zores@alcatel-lucent.fr>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/47] ipv4: fix infinite retry loop in IP-Config
Message-ID: <20090214005845.GU11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv4-fix-infinite-retry-loop-in-ip-config.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Zores <benjamin.zores@alcatel-lucent.fr>

[ Upstream commit 9d8dba6c979fa99c96938c869611b9a23b73efa9 ]

Signed-off-by: Benjamin Zores <benjamin.zores@alcatel-lucent.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ipconfig.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1272,6 +1272,9 @@ __be32 __init root_nfs_parse_addr(char *
 static int __init ip_auto_config(void)
 {
 	__be32 addr;
+#ifdef IPCONFIG_DYNAMIC
+	int retries = CONF_OPEN_RETRIES;
+#endif
 
 #ifdef CONFIG_PROC_FS
 	proc_net_fops_create(&init_net, "pnp", S_IRUGO, &pnp_seq_fops);
@@ -1308,9 +1311,6 @@ static int __init ip_auto_config(void)
 #endif
 	    ic_first_dev->next) {
 #ifdef IPCONFIG_DYNAMIC
-
-		int retries = CONF_OPEN_RETRIES;
-
 		if (ic_dynamic() < 0) {
 			ic_close_devs();
 

