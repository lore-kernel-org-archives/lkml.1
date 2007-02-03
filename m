Return-Path: <linux-kernel-owner+w=401wt.eu-S1946296AbXBCCuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946296AbXBCCuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946262AbXBCCiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:38:09 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52951 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946259AbXBCCiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:38:05 -0500
Message-Id: <20070203024202.157345000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:32 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>,
       Netfilter Development Mailinglist 
	<netfilter-devel@lists.netfilter.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 28/59] NETFILTER: Fix iptables ABI breakage on (at least) CRIS
Content-Disposition: inline; filename=netfilter-fix-iptables-abi-breakage-on-cris.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Patrick McHardy <kaber@trash.net>

With the introduction of x_tables we accidentally broke compatibility
by defining IPT_TABLE_MAXNAMELEN to XT_FUNCTION_MAXNAMELEN instead of
XT_TABLE_MAXNAMELEN, which is two bytes larger.

On most architectures it doesn't really matter since we don't have
any tables with names that long in the kernel and the structure
layout didn't change because of alignment requirements of following
members. On CRIS however (and other architectures that don't align
data) this changed the structure layout and thus broke compatibility
with old iptables binaries.

Changing it back will break compatibility with binaries compiled
against recent kernels again, but since the breakage has only been
there for three releases this seems like the better choice.

Spotted by Jonas Berlin <xkr47@outerspace.dyndns.org>.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 include/linux/netfilter_ipv4/ip_tables.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.2.orig/include/linux/netfilter_ipv4/ip_tables.h
+++ linux-2.6.19.2/include/linux/netfilter_ipv4/ip_tables.h
@@ -28,7 +28,7 @@
 #include <linux/netfilter/x_tables.h>
 
 #define IPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
-#define IPT_TABLE_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define IPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
 #define ipt_match xt_match
 #define ipt_target xt_target
 #define ipt_table xt_table

--
