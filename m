Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXIGQFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXIGQFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932770AbXIGQE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 12:04:58 -0400
Received: from tetrahedron.itechcraft.com ([72.34.45.195]:35803 "EHLO
	tetrahedron.itechcraft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932757AbXIGQE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 12:04:57 -0400
X-Greylist: delayed 4686 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2007 12:04:57 EDT
Message-ID: <46E16450.6050608@yourserveradmin.com>
Date: Fri, 07 Sep 2007 17:46:40 +0300
From: Nikolay Kopitonenko <Nikolay.Kopitonenko@yourserveradmin.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: PATCH  to bug #8876
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - tetrahedron.itechcraft.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - yourserveradmin.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there!

Below is a fix for this:
http://bugzilla.kernel.org/show_bug.cgi?id=8876


Applies to any version since 2.6.22 to latest: 2.6.23-rc5-git1

please apply :)


-------------------------CUT---------------------
diff -urN a/net/ipv4/devinet.c b/net/ipv4/devinet.c
--- a/net/ipv4/devinet.c	2007-07-09 02:32:17.000000000 +0300
+++ b/net/ipv4/devinet.c	2007-08-10 20:33:22.000000000 +0300
@@ -1193,7 +1193,7 @@
 		for (ifa = in_dev->ifa_list, ip_idx = 0; ifa;
 		     ifa = ifa->ifa_next, ip_idx++) {
 			if (ip_idx < s_ip_idx)
-				goto cont;
+				continue;
 			if (inet_fill_ifaddr(skb, ifa, NETLINK_CB(cb->skb).pid,
 					     cb->nlh->nlmsg_seq,
 					     RTM_NEWADDR, NLM_F_MULTI) <= 0)
-------------------------/CUT---------------------

Signed-off-by: Nikolay.Kopitonenko@yourserveradmin.com


Thanks

Nikolay Kopitonenko
