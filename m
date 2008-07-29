Return-Path: <linux-kernel-owner+w=401wt.eu-S1759733AbYG2UJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbYG2UJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYG2UJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:09:11 -0400
Received: from xenotime.net ([66.160.160.81]:60805 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752640AbYG2UJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:09:10 -0400
Date: Tue, 29 Jul 2008 13:05:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>,
       davem@davemloft.net
Subject: [PATCH 3/5] docsrc: fix ifenslave type
Message-ID: <12173619152734@xenotime.net>
In-Reply-To: <12173619152424@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Documentation/networking/ifenslave.c:1084: warning: pointer targets in assignment differ in signedness

>From include/linux/socket.h:
 *	1003.1g requires sa_family_t and that sa_data is char.

and from SUSv3:
(http://www.opengroup.org/onlinepubs/009695399/basedefs/sys/socket.h.html)

The <sys/socket.h> header shall define the sockaddr structure that includes at least the following members:

sa_family_t  sa_family  Address family. 
char         sa_data[]  Socket address (variable-length data).
<end SUSv3>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/networking/ifenslave.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080729.orig/Documentation/networking/ifenslave.c
+++ linux-next-20080729/Documentation/networking/ifenslave.c
@@ -1081,7 +1081,7 @@ static int set_if_addr(char *master_ifna
 
 		}
 
-		ipaddr = ifr.ifr_addr.sa_data;
+		ipaddr = (unsigned char *)ifr.ifr_addr.sa_data;
 		v_print("Interface '%s': set IP %s to %d.%d.%d.%d\n",
 			slave_ifname, ifra[i].desc,
 			ipaddr[0], ipaddr[1], ipaddr[2], ipaddr[3]);


-- 

