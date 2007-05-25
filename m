Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbXEYNCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbXEYNCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXEYNCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:02:42 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:50161
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751348AbXEYNCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:02:41 -0400
Date: Fri, 25 May 2007 15:04:44 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: developers@islsm.org, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/2] use list_for_each() for iteration in Prism 54 driver
Message-ID: <20070525130444.GG31790@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	developers@islsm.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070525125630.GE31790@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525125630.GE31790@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each() in the Prism54 driver to iterate over the MAC list

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 283be4a..34cf13c 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1861,7 +1861,7 @@ prism54_del_mac(struct net_device *ndev, struct iw_request_info *info,
 
 	if (down_interruptible(&acl->sem))
 		return -ERESTARTSYS;
-	for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
+	list_for_each(ptr, &acl->mac_list) {
 		entry = list_entry(ptr, struct mac_entry, _list);
 
 		if (memcmp(entry->addr, addr->sa_data, ETH_ALEN) == 0) {
@@ -1891,7 +1891,7 @@ prism54_get_mac(struct net_device *ndev, struct iw_request_info *info,
 	if (down_interruptible(&acl->sem))
 		return -ERESTARTSYS;
 
-	for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
+	list_for_each(ptr, &acl->mac_list) {
 		entry = list_entry(ptr, struct mac_entry, _list);
 
 		memcpy(dst->sa_data, entry->addr, ETH_ALEN);
@@ -1972,7 +1972,7 @@ prism54_mac_accept(struct islpci_acl *acl, char *mac)
 		return 1;
 	}
 
-	for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
+	list_for_each(ptr, &acl->mac_list) {
 		entry = list_entry(ptr, struct mac_entry, _list);
 		if (memcmp(entry->addr, mac, ETH_ALEN) == 0) {
 			res = 1;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

               If sharing a thing in no way diminishes it,
               it is not rightly owned if it is not shared
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
