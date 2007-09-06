Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbXIFUqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbXIFUqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933066AbXIFUpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:45:35 -0400
Received: from relay1.mail.vrmd.de ([81.28.232.18]:48483 "EHLO
	relay1.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050AbXIFUpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:45:32 -0400
X-Greylist: delayed 2617 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 16:45:32 EDT
Date: Thu, 6 Sep 2007 22:01:52 +0200
From: Bernhard Walle <bernhard@bwalle.de>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] Fix config requirements of IPv6
Message-ID: <20070906200151.GA28306@mail1.bwalle.de>
Mail-Followup-To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Relay-User: bernhard@bwalle.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Fix config requirements of IPv6

net/ipv6/inet6_connection_sock.c in function __inet6_csk_dst_store() requires
flow_cache_genid which is defined in net/core/flow.c which is compiled when
CONFIG_XFRM is set.

This patch expresses that dependency.


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>

---
 net/ipv6/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -5,6 +5,7 @@
 #   IPv6 as module will cause a CRASH if you try to unload it
 config IPV6
 	tristate "The IPv6 protocol"
+	select XFRM
 	default m
 	---help---
 	  This is complemental support for the IP version 6.
