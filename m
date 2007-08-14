Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbXHNHtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbXHNHtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXHNHqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:46:39 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55409 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbXHNHqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:46:18 -0400
Date: Tue, 14 Aug 2007 00:29:24 -0700
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
Subject: [patch 06/12] PPC: Revert "Add mdio to bus scan id list for
	platforms with QE UEC"
Message-ID: <20070814072924.GH15025@kroah.com>
References: <20070814072244.882283903@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ppc-revert-add-mdio-to-bus-scan-id-list-for-platforms-with-qe-uec.patch"
In-Reply-To: <20070814072813.GA15025@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kim Phillips <kim.phillips@freescale.com>

This reverts commit 3baee955953957be5496cd28e9c544d9db214262.

this was a mistake from the start; I added mdio type to the bus
scan list early on in my ucc_geth migrate to phylib development,
which is just pure wrong (the ucc_geth_mii driver creates the mii
bus and the PHY layer handles PHY enumeration without translation).

this accompanies commit 77926826f301fbd8ed96d3cd9ff17a5b59560dfb:

 Revert "[POWERPC] Don't complain if size-cells == 0 in prom_parse()"

which was basically trying to hide a symptom of the original mistake
this revert fixes.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/83xx/mpc832x_mds.c |    1 -
 arch/powerpc/platforms/83xx/mpc832x_rdb.c |    1 -
 arch/powerpc/platforms/83xx/mpc836x_mds.c |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_mds.c |    1 -
 4 files changed, 4 deletions(-)

--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -111,7 +111,6 @@ static struct of_device_id mpc832x_ids[]
 	{ .type = "soc", },
 	{ .compatible = "soc", },
 	{ .type = "qe", },
-	{ .type = "mdio", },
 	{},
 };
 
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -75,7 +75,6 @@ static struct of_device_id mpc832x_ids[]
 	{ .type = "soc", },
 	{ .compatible = "soc", },
 	{ .type = "qe", },
-	{ .type = "mdio", },
 	{},
 };
 
--- a/arch/powerpc/platforms/83xx/mpc836x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc836x_mds.c
@@ -118,7 +118,6 @@ static struct of_device_id mpc836x_ids[]
 	{ .type = "soc", },
 	{ .compatible = "soc", },
 	{ .type = "qe", },
-	{ .type = "mdio", },
 	{},
 };
 
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -147,7 +147,6 @@ static struct of_device_id mpc85xx_ids[]
 	{ .type = "soc", },
 	{ .compatible = "soc", },
 	{ .type = "qe", },
-	{ .type = "mdio", },
 	{},
 };
 

-- 
