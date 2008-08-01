Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYHAFko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYHAFko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYHAFkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:40:37 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:57369 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbYHAFkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:40:35 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net
Subject: [RFC] pci.ids.h: report on 27-rc1-mm1 PCI_* symbols
Date: Fri, 01 Aug 2008 15:40:15 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <ue75945gir8q6h0dpurvjn2gpr1i5q0tvd@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Doug,

Revived an old script to check pci.ids.h and source files in the kernel, 
there's only one driver sub-system defining PCI_* symbols with macros, 
should I submit a patch to unwind the macros?  

There's only 11 of them in 12 files:
grant@pooh64:~/linux$ /home/common/bin/scan-pci.ids linux-2.6.27-rc1-mm1
extract symbols from pci_ids
find files with symbols in source tree
find source symbols, build xref
process any source file containing macros to get their symbols
perform macro expansion to get more symbols
  amd76x_edac.c
  cell_edac.c
  e752x_edac.c
  e7xxx_edac.c
  edac_device.c
  edac_device_sysfs.c
  edac_mc.c
  edac_mc_sysfs.c
  edac_module.c
  edac_pci.c
  edac_pci_sysfs.c
  i3000_edac.c
  i5000_edac.c
  i5100_edac.c
  i82443bxgx_edac.c
  i82860_edac.c
  i82875p_edac.c
  i82975x_edac.c
  mpc85xx_edac.c
  mv64x60_edac.c
  pasemi_edac.c
  r82600_edac.c

extract symbols from macro expansion, appending

found     11 symbols built by macros

source files building symbols with macros:
linux-2.6.27-rc1-mm1/drivers/edac/amd76x_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/e752x_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/e7xxx_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/i3000_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/i5000_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/i5100_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/i82443bxgx_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/i82860_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/i82875p_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/i82975x_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/pasemi_edac.c
linux-2.6.27-rc1-mm1/drivers/edac/r82600_edac.c

discover symbols unique to pci_ids.h or source

PCI_CLASS_ PCI_DEVICE_ PCI_VENDOR_ PCI_SUBDEVICE_ PCI_SUBVENDOR_

found   2700 symbols total
found    434 symbols defined only in source
found    362 symbols defined only in pci.ids

wc -l symbols-*
   362 symbols-pci-ids.h-defined-only
  2266 symbols-pci_ids.h-defined
     1 symbols-pci_ids.h-duplicates
   434 symbols-source-defined-only
    12 symbols-source-file-has-macro
    22 symbols-source-file-macro-c
     2 symbols-source-file-macro-define
  4158 symbols-source-file-xref-symbol
   123 symbols-source-only-files
  2338 symbols-source-symbol
  2700 symbols-total
 12418 total

pci_ids.h duplicate symbols:
PCI_VENDOR_ID_RDC

That lonely duplicated symbol may be taken care of already?  If not, 
a patchlet below.

Thanks,
Grant.

From: Grant Coady <gcoady.lk@gmail.com>

pci.ids.h: remove a duplicated symbol

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 pci_ids.h |    2 --
 1 files changed, 2 deletions(-)

--- linux-2.6.27-rc1-mm1a/include/linux/pci_ids.h~	2008-07-30 19:42:45.910186385 +1000
+++ linux-2.6.27-rc1-mm1a/include/linux/pci_ids.h	2008-08-01 15:33:56.211527924 +1000
@@ -2177,8 +2177,6 @@
 #define PCI_DEVICE_ID_HERC_WIN		0x5732
 #define PCI_DEVICE_ID_HERC_UNI		0x5832
 
-#define PCI_VENDOR_ID_RDC		0x17f3
-
 #define PCI_VENDOR_ID_SITECOM		0x182d
 #define PCI_DEVICE_ID_SITECOM_DC105V2	0x3069
 
