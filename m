Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbYKDXvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbYKDXvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbYKDXkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:05 -0500
Received: from mx1.suse.de ([195.135.220.2]:47678 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbYKDXkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:40:04 -0500
Date: Tue, 4 Nov 2008 15:32:56 -0800
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
       alan@lxorguk.ukuu.org.uk, Peter Chubb <peterc@gelato.unsw.edu.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [patch 38/57] PCI: fix 64-vbit prefetchable memory resource BARs
Message-ID: <20081104233256.GM659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-fix-64-vbit-prefetchable-memory-resource-bars.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Chubb <peterc@gelato.unsw.edu.au>

commit e354597cce8d219d135d65e585dc4f30323486b9 upstream.

Since patch 6ac665c63dcac8fcec534a1d224ecbb8b867ad59 my infiniband
controller hasn't worked.  This is because it has 64-bit prefetchable
memory, which was mistakenly being  taken to be 32-bit memory.  The
resource flags in this case are PCI_BASE_ADDRESS_MEM_TYPE_64 |
PCI_BASE_ADDRESS_MEM_PREFETCH.

This patch checks only for the PCI_BASE_ADDRESS_MEM_TYPE_64 bit; thus
whether the region is prefetchable or not is ignored.  This fixes my
Infiniband.

Reviewed-by: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -219,7 +219,7 @@ static inline enum pci_bar_type decode_b
 
 	res->flags = bar & ~PCI_BASE_ADDRESS_MEM_MASK;
 
-	if (res->flags == PCI_BASE_ADDRESS_MEM_TYPE_64)
+	if (res->flags & PCI_BASE_ADDRESS_MEM_TYPE_64)
 		return pci_bar_mem64;
 	return pci_bar_mem32;
 }

-- 
