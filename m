Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXIUJPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXIUJPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbXIUJPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:15:06 -0400
Received: from hq.materiel.net ([195.167.193.66]:45600 "EHLO hq.materiel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbXIUJPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:15:04 -0400
X-Greylist: delayed 1193 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2007 05:15:03 EDT
Date: Fri, 21 Sep 2007 10:55:08 +0200
From: "Gregory 'GaLi' Cavelier" <gali@cleia.org>
To: kkeil@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ISDN: Change pci_find_device() calls to pci_get_device()
Message-Id: <20070921105508.d1a6a369.gali@cleia.org>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch removes the obsolete pci_find_device() calls and replaces them with pci_get_device() for all ISDN drivers.

Compilation is fine but I haven't tested it since I don't own a ISDN card. Should be fine since the return value and parameters of pci_find_device() and pci_get_device() are the same.

The is my first patch so be nice to me  :)

I hope it's not too long, I can split it if you prefer.

Signed-off-by: Gregory 'GaLi' Cavelier <gali@cleia.org>

diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index 28e2667..b04a178 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -789,7 +789,7 @@ setup_avm_pcipnp(struct IsdnCard *card)
        }
 #endif
 #ifdef CONFIG_PCI
-       if ((dev_avm = pci_get_device(PCI_VENDOR_ID_AVM,
+       if ((dev_avm = pci_find_device(PCI_VENDOR_ID_AVM,
                PCI_DEVICE_ID_AVM_A1,  dev_avm))) {
                if (pci_enable_device(dev_avm))
                        return(0);
diff --git a/drivers/isdn/hisax/bkm_a4t.c b/drivers/isdn/hisax/bkm_a4t.c
index b5e761d..3d1bdc8 100644
--- a/drivers/isdn/hisax/bkm_a4t.c
+++ b/drivers/isdn/hisax/bkm_a4t.c
@@ -340,7 +340,7 @@ setup_bkm_a4t(struct IsdnCard *card)
        } else
                return (0);
 
-       while ((dev_a4t = pci_get_device(PCI_VENDOR_ID_ZORAN,
+       while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
                PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
                ret = a4t_pci_probe(dev_a4t, cs, &found, &pci_memaddr);
                if (!ret)
diff --git a/drivers/isdn/hisax/bkm_a8.c b/drivers/isdn/hisax/bkm_a8.c
index 340313f..6339bb4 100644
--- a/drivers/isdn/hisax/bkm_a8.c
+++ b/drivers/isdn/hisax/bkm_a8.c
@@ -309,7 +309,7 @@ setup_sct_quadro(struct IsdnCard *card)
                (sub_vendor_id != PCI_VENDOR_ID_BERKOM)))
                return (0);
        if (cs->subtyp == SCT_1) {
-               while ((dev_a8 = pci_get_device(PCI_VENDOR_ID_PLX,
+               while ((dev_a8 = pci_find_device(PCI_VENDOR_ID_PLX,
                        PCI_DEVICE_ID_PLX_9050, dev_a8))) {
                        
                        sub_vendor_id = dev_a8->subsystem_vendor;
diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 8c7b03e..6eebeb4 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -1047,21 +1047,21 @@ setup_diva(struct IsdnCard *card)
 #endif
 #ifdef CONFIG_PCI
                cs->subtyp = 0;
-               if ((dev_diva = pci_get_device(PCI_VENDOR_ID_EICON,
+               if ((dev_diva = pci_find_device(PCI_VENDOR_ID_EICON,
                        PCI_DEVICE_ID_EICON_DIVA20, dev_diva))) {
                        if (pci_enable_device(dev_diva))
                                return(0);
                        cs->subtyp = DIVA_PCI;
                        cs->irq = dev_diva->irq;
                        cs->hw.diva.cfg_reg = pci_resource_start(dev_diva, 2);
-               } else if ((dev_diva_u = pci_get_device(PCI_VENDOR_ID_EICON,
+               } else if ((dev_diva_u = pci_find_device(PCI_VENDOR_ID_EICON,
                        PCI_DEVICE_ID_EICON_DIVA20_U, dev_diva_u))) {
                        if (pci_enable_device(dev_diva_u))
                                return(0);
                        cs->subtyp = DIVA_PCI;
                        cs->irq = dev_diva_u->irq;
                        cs->hw.diva.cfg_reg = pci_resource_start(dev_diva_u, 2);
-               } else if ((dev_diva201 = pci_get_device(PCI_VENDOR_ID_EICON,
+               } else if ((dev_diva201 = pci_find_device(PCI_VENDOR_ID_EICON,
                        PCI_DEVICE_ID_EICON_DIVA201, dev_diva201))) {
                        if (pci_enable_device(dev_diva201))
                                return(0);
@@ -1071,7 +1071,7 @@ setup_diva(struct IsdnCard *card)
                                (ulong) ioremap(pci_resource_start(dev_diva201, 0), 4096);
                        cs->hw.diva.cfg_reg =
                                (ulong) ioremap(pci_resource_start(dev_diva201, 1), 4096);
-               } else if ((dev_diva202 = pci_get_device(PCI_VENDOR_ID_EICON,
+               } else if ((dev_diva202 = pci_find_device(PCI_VENDOR_ID_EICON,
                        PCI_DEVICE_ID_EICON_DIVA202, dev_diva202))) {
                        if (pci_enable_device(dev_diva202))
                                return(0);
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index 2932755..fab3e4e 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -1021,7 +1021,7 @@ setup_elsa(struct IsdnCard *card)
        } else if (cs->typ == ISDN_CTYPE_ELSA_PCI) {
 #ifdef CONFIG_PCI
                cs->subtyp = 0;
-               if ((dev_qs1000 = pci_get_device(PCI_VENDOR_ID_ELSA,
+               if ((dev_qs1000 = pci_find_device(PCI_VENDOR_ID_ELSA,
                        PCI_DEVICE_ID_ELSA_MICROLINK, dev_qs1000))) {
                        if (pci_enable_device(dev_qs1000))
                                return(0);
@@ -1029,7 +1029,7 @@ setup_elsa(struct IsdnCard *card)
                        cs->irq = dev_qs1000->irq;
                        cs->hw.elsa.cfg = pci_resource_start(dev_qs1000, 1);
                        cs->hw.elsa.base = pci_resource_start(dev_qs1000, 3);
-               } else if ((dev_qs3000 = pci_get_device(PCI_VENDOR_ID_ELSA,
+               } else if ((dev_qs3000 = pci_find_device(PCI_VENDOR_ID_ELSA,
                        PCI_DEVICE_ID_ELSA_QS3000, dev_qs3000))) {
                        if (pci_enable_device(dev_qs3000))
                                return(0);
diff --git a/drivers/isdn/hisax/enternow_pci.c b/drivers/isdn/hisax/enternow_pci.c
index 1be5a2b..b73027f 100644
--- a/drivers/isdn/hisax/enternow_pci.c
+++ b/drivers/isdn/hisax/enternow_pci.c
@@ -406,7 +406,7 @@ setup_enternow_pci(struct IsdnCard *card)
 
        for ( ;; )
        {
-               if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
+               if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
                        PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
                        ret = en_pci_probe(dev_netjet, cs);
                        if (!ret)
diff --git a/drivers/isdn/hisax/gazel.c b/drivers/isdn/hisax/gazel.c
index 24aa5be..3efa719 100644
--- a/drivers/isdn/hisax/gazel.c
+++ b/drivers/isdn/hisax/gazel.c
@@ -546,7 +546,7 @@ setup_gazelpci(struct IsdnCardState *cs)
        found = 0;
        seekcard = PCI_DEVICE_ID_PLX_R685;
        for (nbseek = 0; nbseek < 4; nbseek++) {
-               if ((dev_tel = pci_get_device(PCI_VENDOR_ID_PLX,
+               if ((dev_tel = pci_find_device(PCI_VENDOR_ID_PLX,
                                        seekcard, dev_tel))) {
                        if (pci_enable_device(dev_tel))
                                return 1;
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 91a7334..077080a 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -1660,7 +1660,7 @@ setup_hfcpci(struct IsdnCard *card)
 
        i = 0;
        while (id_list[i].vendor_id) {
-               tmp_hfcpci = pci_get_device(id_list[i].vendor_id,
+               tmp_hfcpci = pci_find_device(id_list[i].vendor_id,
                                             id_list[i].device_id,
                                             dev_hfcpci);
                i++;
diff --git a/drivers/isdn/hisax/niccy.c b/drivers/isdn/hisax/niccy.c
index 099fd4a..e5918c6 100644
--- a/drivers/isdn/hisax/niccy.c
+++ b/drivers/isdn/hisax/niccy.c
@@ -302,7 +302,7 @@ int __devinit setup_niccy(struct IsdnCard *card)
 #ifdef CONFIG_PCI
                u_int pci_ioaddr;
                cs->subtyp = 0;
-               if ((niccy_dev = pci_get_device(PCI_VENDOR_ID_SATSAGEM,
+               if ((niccy_dev = pci_find_device(PCI_VENDOR_ID_SATSAGEM,
                                                 PCI_DEVICE_ID_SATSAGEM_NICCY,
                                                 niccy_dev))) {
                        if (pci_enable_device(niccy_dev))
diff --git a/drivers/isdn/hisax/nj_s.c b/drivers/isdn/hisax/nj_s.c
index 3535378..fa2db87 100644
--- a/drivers/isdn/hisax/nj_s.c
+++ b/drivers/isdn/hisax/nj_s.c
@@ -277,7 +277,7 @@ setup_netjet_s(struct IsdnCard *card)
 
        for ( ;; )
        {
-               if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
+               if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
                        PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
                        ret = njs_pci_probe(dev_netjet, cs);
                        if (!ret)
diff --git a/drivers/isdn/hisax/nj_u.c b/drivers/isdn/hisax/nj_u.c
index 1ab471d..f017d38 100644
--- a/drivers/isdn/hisax/nj_u.c
+++ b/drivers/isdn/hisax/nj_u.c
@@ -240,7 +240,7 @@ setup_netjet_u(struct IsdnCard *card)
 
        for ( ;; )
        {
-               if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
+               if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
                        PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
                        ret = nju_pci_probe(dev_netjet, cs);
                        if (!ret)
diff --git a/drivers/isdn/hisax/sedlbauer.c b/drivers/isdn/hisax/sedlbauer.c
index cbd506e..ad06f3c 100644
--- a/drivers/isdn/hisax/sedlbauer.c
+++ b/drivers/isdn/hisax/sedlbauer.c
@@ -624,7 +624,7 @@ setup_sedlbauer(struct IsdnCard *card)
 #endif
 /* Probe for Sedlbauer speed pci */
 #ifdef CONFIG_PCI
-               if ((dev_sedl = pci_get_device(PCI_VENDOR_ID_TIGERJET,
+               if ((dev_sedl = pci_find_device(PCI_VENDOR_ID_TIGERJET,
                                PCI_DEVICE_ID_TIGERJET_100, dev_sedl))) {
                        if (pci_enable_device(dev_sedl))
                                return(0);
diff --git a/drivers/isdn/hisax/telespci.c b/drivers/isdn/hisax/telespci.c
index 248c307..d09f6d0 100644
--- a/drivers/isdn/hisax/telespci.c
+++ b/drivers/isdn/hisax/telespci.c
@@ -300,7 +300,7 @@ setup_telespci(struct IsdnCard *card)
        if (cs->typ != ISDN_CTYPE_TELESPCI)
                return (0);
 #ifdef CONFIG_PCI
-       if ((dev_tel = pci_get_device (PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
+       if ((dev_tel = pci_find_device (PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
                if (pci_enable_device(dev_tel))
                        return(0);
                cs->irq = dev_tel->irq;
diff --git a/drivers/isdn/hisax/w6692.c b/drivers/isdn/hisax/w6692.c
index 6b4317d..3aeceaf 100644
--- a/drivers/isdn/hisax/w6692.c
+++ b/drivers/isdn/hisax/w6692.c
@@ -1011,7 +1011,7 @@ setup_w6692(struct IsdnCard *card)
                return (0);
 #ifdef CONFIG_PCI
        while (id_list[id_idx].vendor_id) {
-               dev_w6692 = pci_get_device(id_list[id_idx].vendor_id,
+               dev_w6692 = pci_find_device(id_list[id_idx].vendor_id,
                                            id_list[id_idx].device_id,
                                            dev_w6692);
                if (dev_w6692) {
diff --git a/drivers/isdn/hysdn/hysdn_init.c b/drivers/isdn/hysdn/hysdn_init.c
index 5333d63..9e01748 100644
--- a/drivers/isdn/hysdn/hysdn_init.c
+++ b/drivers/isdn/hysdn/hysdn_init.c
@@ -76,7 +76,7 @@ search_cards(void)
 
        card_root = NULL;
        card_last = NULL;
-       while ((akt_pcidev = pci_get_device(PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
+       while ((akt_pcidev = pci_find_device(PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
                                             akt_pcidev)) != NULL) {
                if (pci_enable_device(akt_pcidev))
                        continue;

-- 
Gregory 'GaLi' Cavelier
                        _
 ASCII ribbon campaign ( )
 - against HTML email   X
              & vCards / \
