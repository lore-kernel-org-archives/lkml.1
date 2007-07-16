Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbXGPKyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbXGPKyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbXGPKyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:54:03 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:1172 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbXGPKyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:54:01 -0400
Date: Mon, 16 Jul 2007 12:53:52 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: <linux-netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, netfilter-devel@lists.netfilter.org,
       "David S. Miller" <davem@davemloft.net>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: xt_connlimit needs to depend on nf_conntrack
Message-ID: <20070716125352.3525ec5b@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With NF_CONNTRACK=n, NETFILTER_XT_MATCH_CONNLIMIT=m I get the
following errors on current git:

  CC [M]  net/netfilter/xt_connlimit.o
  In file included from net/netfilter/xt_connlimit.c:27:
  include/net/netfilter/nf_conntrack.h:100: error: field 'ct_general' has incomplete type
  include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
  include/net/netfilter/nf_conntrack.h:164: error: 'const struct sk_buff' has no member named 'nfct'
  include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
  include/net/netfilter/nf_conntrack.h:171: warning: implicit declaration of function 'nf_conntrack_put'
  include/net/netfilter/nf_conntrack.h: In function 'nf_ct_is_untracked':
  include/net/netfilter/nf_conntrack.h:253: error: 'const struct sk_buff' has no member named 'nfct'
  In file included from net/netfilter/xt_connlimit.c:28:
  include/net/netfilter/nf_conntrack_core.h: In function 'nf_conntrack_confirm':
  include/net/netfilter/nf_conntrack_core.h:68: error: 'struct sk_buff' has no member named 'nfct'

Adding a dependency in Kconfig fixes this.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---

 net/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3ac39f1..3599770 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -436,6 +436,7 @@ config NETFILTER_XT_MATCH_CONNBYTES
 config NETFILTER_XT_MATCH_CONNLIMIT
 	tristate '"connlimit" match support"'
 	depends on NETFILTER_XTABLES
+	depends on NF_CONNTRACK
 	---help---
 	  This match allows you to match against the number of parallel
 	  connections to a server per client IP address (or address block).
