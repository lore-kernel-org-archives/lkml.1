Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbZDKTBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbZDKTBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZDKTB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:01:28 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59220 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZDKTB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BndrQVeJRA5K5k+LK2w19tGxmnmBDgl2aWf/UFKJb4EkYtQhs8ZnOEkcRO+rs8Myfv
         ayG4La3v7GkREXtsvaUYHcw7/cvREvXXUXJ8O0iZ2hnCn6lTw5nxkjDiCp+TAIQ19kU9
         //BCbTCVS9TrAJYUaG79eAs7/aREdMetUkDM0=
Date: Sat, 11 Apr 2009 23:01:21 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] agnx: replace print_mac with %pM
Message-ID: <20090411190121.GA18885@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/agnx/debug.h |    9 ++++-----
 drivers/staging/agnx/pci.c   |    8 +++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/agnx/debug.h b/drivers/staging/agnx/debug.h
index 761d99c..7947f32 100644
--- a/drivers/staging/agnx/debug.h
+++ b/drivers/staging/agnx/debug.h
@@ -312,7 +312,6 @@ static inline void dump_ieee80211_hdr(struct ieee80211_hdr *hdr, char *tag)
 {
 	u16 fctl;
 	int hdrlen;
-	DECLARE_MAC_BUF(mac);
 
 	fctl = le16_to_cpu(hdr->frame_control);
 	switch (fctl & IEEE80211_FCTL_FTYPE) {
@@ -375,13 +374,13 @@ static inline void dump_ieee80211_hdr(struct ieee80211_hdr *hdr, char *tag)
 		printk("FC=0x%04x DUR=0x%04x",
 		       fctl, le16_to_cpu(hdr->duration_id));
 	if (hdrlen >= 10)
-		printk(" A1=%s", print_mac(mac, hdr->addr1));
+		printk(" A1=%pM", hdr->addr1);
 	if (hdrlen >= 16)
-		printk(" A2=%s", print_mac(mac, hdr->addr2));
+		printk(" A2=%pM", hdr->addr2);
 	if (hdrlen >= 24)
-		printk(" A3=%s", print_mac(mac, hdr->addr3));
+		printk(" A3=%pM", hdr->addr3);
 	if (hdrlen >= 30)
-		printk(" A4=%s", print_mac(mac, hdr->addr4));
+		printk(" A4=%pM", hdr->addr4);
 	printk("\n");
 }
 
diff --git a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
index 25c0ffd..6029540 100644
--- a/drivers/staging/agnx/pci.c
+++ b/drivers/staging/agnx/pci.c
@@ -150,8 +150,7 @@ static int agnx_get_mac_address(struct agnx_priv *priv)
 	*((u32 *)(priv->mac_addr + 2)) = cpu_to_le32(reg);
 
 	if (!is_valid_ether_addr(priv->mac_addr)) {
-		DECLARE_MAC_BUF(mbuf);
-		printk(KERN_WARNING PFX "read mac %s\n", print_mac(mbuf, priv->mac_addr));
+		printk(KERN_WARNING PFX "read mac %pM\n", priv->mac_addr);
 		printk(KERN_WARNING PFX "Invalid hwaddr! Using random hwaddr\n");
 		random_ether_addr(priv->mac_addr);
 	}
@@ -455,7 +454,6 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 	u32 mem_addr0, mem_len0;
 	u32 mem_addr1, mem_len1;
 	int err;
-	DECLARE_MAC_BUF(mac);
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -559,8 +557,8 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 	agnx_hw_reset(priv);
 
 
-	printk(PFX "%s: hwaddr %s, Rev 0x%02x\n", wiphy_name(dev->wiphy),
-	       print_mac(mac, dev->wiphy->perm_addr), priv->revid);
+	printk(PFX "%s: hwaddr %pM, Rev 0x%02x\n", wiphy_name(dev->wiphy),
+	       dev->wiphy->perm_addr, priv->revid);
 	return 0;
 
  err_iounmap:
