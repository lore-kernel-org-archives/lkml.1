Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbZCNBuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbZCNBuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbZCNBVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:39 -0400
Received: from kroah.org ([198.145.64.141]:35641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754698AbZCNBVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:43 2009
Message-Id: <20090314011043.647123722@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andres Salomon <dilinger@debian.org>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 083/114] sdhci: Add NO_BUSY_IRQ quirk for Marvell CAFE host chip
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=sdhci-add-no_busy_irq-quirk-for-marvell-cafe-host-chip.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andres Salomon <dilinger@debian.org>

commit a0874897b1ba106298e4303a25456a473fc40f3d upstream.

As described here: http://lkml.org/lkml/2009/2/20/265

The CAFE chip is broken due to commit e809517f6fa5803a5a1cd5602.
Anton added a quirk here: http://lkml.org/lkml/2009/2/20/279 that fixes
CAFE's problem.  This adds the quirk for CAFE.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci-pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -107,6 +107,7 @@ static const struct sdhci_pci_fixes sdhc
 
 static const struct sdhci_pci_fixes sdhci_cafe = {
 	.quirks		= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
+			  SDHCI_QUIRK_NO_BUSY_IRQ |
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
 


