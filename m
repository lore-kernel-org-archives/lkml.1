Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbXHNHvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbXHNHvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbXHNHql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:46:41 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55403 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXHNHqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:46:18 -0400
Date: Tue, 14 Aug 2007 00:29:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Rutger Nijlunsing <rutger@nospam.com>,
       Kim Phillips <kim.phillips@freescale.com>
Subject: [patch 05/12] PPC: Revert "Dont complain if size-cells == 0 in
	prom_parse()"
Message-ID: <20070814072912.GF15025@kroah.com>
References: <20070814072244.882283903@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ppc-revert-don-t-complain-if-size-cells-0-in-prom_parse.patch"
In-Reply-To: <20070814072813.GA15025@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Paul Mackerras <paulus@samba.org>

This reverts commit fd6e9d3945ee122eb513ada8b17296d243c1ce5e.

Having #size-cells == 0 in a node indicates that things under the
node aren't directly accessible, and therefore we shouldn't try to
translate addresses for devices under the node into CPU physical
addresses.

Some drivers, such as the nvram driver for powermacs, rely on
of_address_to_resource failing if they are called for a node
representing a device whose resources aren't directly accessible
by the CPU.  These drivers were broken by commit fd6e9d39,
resulting in the "Lombard" powerbook hanging early in the boot
process.

stable team, this patch is equivalent to commit

77926826f301fbd8ed96d3cd9ff17a5b59560dfb

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/prom_parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/prom_parse.c
+++ b/arch/powerpc/kernel/prom_parse.c
@@ -24,7 +24,7 @@
 /* Max address size we deal with */
 #define OF_MAX_ADDR_CELLS	4
 #define OF_CHECK_COUNTS(na, ns)	((na) > 0 && (na) <= OF_MAX_ADDR_CELLS && \
-			(ns) >= 0)
+			(ns) > 0)
 
 static struct of_bus *of_match_bus(struct device_node *np);
 static int __of_address_to_resource(struct device_node *dev,

-- 
