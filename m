Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbXDZRKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbXDZRKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbXDZRJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:09:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39505 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbXDZQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:59:39 -0400
Date: Thu, 26 Apr 2007 09:55:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Tom spot Callaway <tcallawa@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 13/33] Fix bogus inline directive in sparc64 PCI code
Message-ID: <20070426165554.GN1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-bogus-inline-directive-in-sparc64-pci-code.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tom "spot" Callaway <tcallawa@redhat.com>

[SPARC64]: Fix inline directive in pci_iommu.c

While building a test kernel for the new esp driver (against
git-current), I hit this bug. Trivial fix, put the inline declaration
in the right place. :)

Signed-off-by: Tom "spot" Callaway <tcallawa@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/pci_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc64/kernel/pci_iommu.c
+++ b/arch/sparc64/kernel/pci_iommu.c
@@ -64,7 +64,7 @@ static void __iommu_flushall(struct pci_
 #define IOPTE_IS_DUMMY(iommu, iopte)	\
 	((iopte_val(*iopte) & IOPTE_PAGE) == (iommu)->dummy_page_pa)
 
-static void inline iopte_make_dummy(struct pci_iommu *iommu, iopte_t *iopte)
+static inline void iopte_make_dummy(struct pci_iommu *iommu, iopte_t *iopte)
 {
 	unsigned long val = iopte_val(*iopte);
 

-- 
