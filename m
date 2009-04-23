Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZDWA5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZDWA5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZDWA5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:57:46 -0400
Received: from exprod6ob114.obsmtp.com ([64.18.1.32]:34901 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751240AbZDWA5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:57:45 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] net/ipv6/sysctl_net_ipv6.c: fix sparse warnings
Date: Wed, 22 Apr 2009 20:57:32 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090165F138@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/ipv6/sysctl_net_ipv6.c: fix sparse warnings
Thread-Index: AcnDrnukgbYn+TezRf24OJyotYZPkA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Apr 2009 00:57:43.0640 (UTC) FILETIME=[8268C580:01C9C3AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two sparse warnings in net/ipv6/sysctl_net_ipv6.c.

Both sparse warnings are as follows:

  warning: symbol 'ipv6_table' shadows an earlier one

ipv6_sysctl_net_init() and ipv6_sysctl_net_exit() both use the same
symbol name for the struct ctl_table used to do the 
{register/unregister}_net_sysctl_table().

The static symbol is only used in ipv6_sysctl_register() for the
struct ctl_table used to do the register_net_sysctl_rotable().

Rename the static symbol to ipv6_rotable to remove the sparse warnings.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index a031034..0dc6a4e 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -40,7 +40,7 @@ static ctl_table ipv6_table_template[] = {
 	{ .ctl_name = 0 }
 };
 
-static ctl_table ipv6_table[] = {
+static ctl_table ipv6_rotable[] = {
 	{
 		.ctl_name	= NET_IPV6_MLD_MAX_MSF,
 		.procname	= "mld_max_msf",
@@ -130,7 +130,7 @@ int ipv6_sysctl_register(void)
 {
 	int err = -ENOMEM;
 
-	ip6_header = register_net_sysctl_rotable(net_ipv6_ctl_path, ipv6_table);
+	ip6_header = register_net_sysctl_rotable(net_ipv6_ctl_path, ipv6_rotable);
 	if (ip6_header == NULL)
 		goto out;
  
