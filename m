Return-Path: <linux-kernel-owner+w=401wt.eu-S971890AbXILSZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971890AbXILSZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970190AbXILSZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:25:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48617 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967949AbXILSZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:25:18 -0400
Date: Wed, 12 Sep 2007 11:22:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, kgdb-bugreport@lists.sourceforge.net,
       amitkale@linsyssoft.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       jason.wessel@windriver.com, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm v2] 2.6.23-rc4-mm1: kgdboe link errors
Message-Id: <20070912112252.7658b7db.randy.dunlap@oracle.com>
In-Reply-To: <20070912181512.GQ4219@waste.org>
References: <46E7B1EA.2040009@gmail.com>
	<20070912101537.129d10c7.randy.dunlap@oracle.com>
	<20070912181512.GQ4219@waste.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 13:15:12 -0500 Matt Mackall wrote:

> NETCONSOLE shouldn't be necessary. Otherwise this looks ok to my
> kconfig-addled brain.

Correct.  Patch corrected.  Thanks.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kgdb build problems:
  Building modules, stage 2.
ERROR: "netpoll_cleanup" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_setup" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_parse_options" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_poll" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_send_udp" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_set_trap" [drivers/net/kgdboe.ko] undefined!
make[1]: *** [__modpost] Error 1


Add 'select' for net-poll related config symbols, but
make KGDBOE 'depend on' NET.  We don't want to 'select' CONFIG_NET,
but if it is already enabled, the 'select's will enable the rest
of the needed interfaces.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/Kconfig.kgdb |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1.orig/lib/Kconfig.kgdb
+++ linux-2.6.23-rc4-mm1/lib/Kconfig.kgdb
@@ -174,9 +174,10 @@ endchoice
 
 config KGDBOE
 	tristate "KGDB: On ethernet" if !KGDBOE_NOMODULE
-	depends on m && KGDB
+	depends on m && KGDB && NET
 	select NETPOLL
 	select NETPOLL_TRAP
+	select NET_POLL_CONTROLLER
 	help
 	  Uses the NETPOLL API to communicate with the host GDB via UDP.
 	  In order for this to work, the ethernet interface specified must
