Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbZCNBZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbZCNBZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZCNBT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:57 -0400
Received: from kroah.org ([198.145.64.141]:34866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752116AbZCNBT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:33 2009
Message-Id: <20090314011033.590487332@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:52 -0700
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
       alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 015/114] PCI quirk: enable MSI on 8132
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=pci-quirk-enable-msi-on-8132.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit e0ae4f5503235ba4449ffb5bcb4189edcef4d584 upstream.

David reported that LSI SAS doesn't work with MSI.  It turns out that
his BIOS doesn't enable it, but the HT MSI 8132 does support HT MSI.
Add quirk to enable it

Reported-by: David Lang <david@lang.hm>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1778,7 +1778,6 @@ static void __devinit quirk_msi_ht_cap(s
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
 
-
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
  */
@@ -1829,6 +1828,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
 			 PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
 			 ht_enable_msi_mapping);
 
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8132_BRIDGE,
+			 ht_enable_msi_mapping);
+
 /* The P5N32-SLI Premium motherboard from Asus has a problem with msi
  * for the MCP55 NIC. It is not yet determined whether the msi problem
  * also affects other devices. As for now, turn off msi for this device.


