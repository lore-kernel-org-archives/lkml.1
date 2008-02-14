Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbYBNH0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbYBNH0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764993AbYBNH0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:26:07 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:27689 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756897AbYBNH0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:26:05 -0500
Date: Thu, 14 Feb 2008 16:24:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] net: xfrm statistics depend on INET.
Message-ID: <20080214072452.GF12436@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/built-in.o: In function `xfrm_policy_init':
/home/pmundt/devel/git/sh-2.6.25/net/xfrm/xfrm_policy.c:2338: undefined reference to `snmp_mib_init'

snmp_mib_init() is only built in if CONFIG_INET is set.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 net/xfrm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 8f9dbec..9201ef8 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -38,7 +38,7 @@ config XFRM_MIGRATE
 
 config XFRM_STATISTICS
 	bool "Transformation statistics (EXPERIMENTAL)"
-	depends on XFRM && PROC_FS && EXPERIMENTAL
+	depends on INET && XFRM && PROC_FS && EXPERIMENTAL
 	---help---
 	  This statistics is not a SNMP/MIB specification but shows
 	  statistics about transformation error (or almost error) factor
