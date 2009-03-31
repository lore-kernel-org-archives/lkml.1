Return-Path: <linux-kernel-owner+w=401wt.eu-S1763896AbZCaXfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763896AbZCaXfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763992AbZCaXVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:38 -0400
Received: from sous-sol.org ([216.99.217.87]:33276 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763907AbZCaXVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:36 -0400
Message-Id: <20090331231651.420308696@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:16 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 31/45] ARM: fix leak in iop13xx/pci
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=arm-fix-leak-in-iop13xx-pci.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

upstream commit: b23c7a427e4b3764ad686a46de89ab652811c50a

Another leak found by Daniel Marjamäki

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/arm/mach-iop13xx/pci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -1026,8 +1026,10 @@ int iop13xx_pci_setup(int nr, struct pci
 		which_atu = 0;
 	}
 
-	if (!which_atu)
+	if (!which_atu) {
+		kfree(res);
 		return 0;
+	}
 
 	switch(which_atu) {
 	case IOP13XX_INIT_ATU_ATUX:
@@ -1074,6 +1076,7 @@ int iop13xx_pci_setup(int nr, struct pci
 		sys->map_irq = iop13xx_pcie_map_irq;
 		break;
 	default:
+		kfree(res);
 		return 0;
 	}
 

