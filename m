Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbZHLJUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbZHLJUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZHLJUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:20:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:7058 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbZHLJUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ucsXpzo964KkPf0X9FYd+MOHGGcbSVaNuiiqTAkPT3mYsMUNszgNh+mNBI2IGq1nbS
         g/G1XXoTF73Eba4xaad6/v61LnXLYQBDidp+CGUamWc23dQ+moGWKskl/xNlUEgVTSx4
         9CqGDLN1EAMylNX7il1FbdoDm9u3YnMRve830=
MIME-Version: 1.0
Date: Wed, 12 Aug 2009 17:20:11 +0800
Message-ID: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
Subject: [RFC patch] init default dma_ops to prepare intel_iommu_init failure
From: Luming Yu <luming.yu@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=000e0cd32c086eb9fb0470ee539e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd32c086eb9fb0470ee539e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi there,

On ia64 platform with dmar table and new upstream
kernel(config_dmar_default_on enabled),
if intel_iommu_init ends up without dma_ops initialized or other iommu
failures.
We got nothing to fall back. The following patch fixes it.

Please review. If make sense, please apply.

**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is for review, please apply attached  patch*/

Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

arch/ia64/kernel/pci-swiotlb.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 223abb1..d5dcaf5 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -46,15 +46,13 @@ void __init swiotlb_dma_init(void)

 void __init pci_swiotlb_init(void)
 {
-	if (!iommu_detected || iommu_pass_through) {
 #ifdef CONFIG_IA64_GENERIC
-		swiotlb = 1;
-		printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
-		machvec_init("dig");
-		swiotlb_init();
-		dma_ops = &swiotlb_dma_ops;
+	swiotlb = 1;
+	printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
+	machvec_init("dig");
+	swiotlb_init();
+	dma_ops = &swiotlb_dma_ops;
 #else
-		panic("Unable to find Intel IOMMU");
+	panic("Unable to find Intel IOMMU");
 #endif
-	}
 }

--000e0cd32c086eb9fb0470ee539e
Content-Type: application/octet-stream; name=5
Content-Disposition: attachment; filename=5
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fy9up8au0

ZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9rZXJuZWwvcGNpLXN3aW90bGIuYyBiL2FyY2gvaWE2NC9r
ZXJuZWwvcGNpLXN3aW90bGIuYwppbmRleCAyMjNhYmIxLi5kNWRjYWY1IDEwMDY0NAotLS0gYS9h
cmNoL2lhNjQva2VybmVsL3BjaS1zd2lvdGxiLmMKKysrIGIvYXJjaC9pYTY0L2tlcm5lbC9wY2kt
c3dpb3RsYi5jCkBAIC00NiwxNSArNDYsMTMgQEAgdm9pZCBfX2luaXQgc3dpb3RsYl9kbWFfaW5p
dCh2b2lkKQogCiB2b2lkIF9faW5pdCBwY2lfc3dpb3RsYl9pbml0KHZvaWQpCiB7Ci0JaWYgKCFp
b21tdV9kZXRlY3RlZCB8fCBpb21tdV9wYXNzX3Rocm91Z2gpIHsKICNpZmRlZiBDT05GSUdfSUE2
NF9HRU5FUklDCi0JCXN3aW90bGIgPSAxOwotCQlwcmludGsoS0VSTl9JTkZPICJQQ0ktRE1BOiBS
ZS1pbml0aWFsaXplIG1hY2hpbmUgdmVjdG9yLlxuIik7Ci0JCW1hY2h2ZWNfaW5pdCgiZGlnIik7
Ci0JCXN3aW90bGJfaW5pdCgpOwotCQlkbWFfb3BzID0gJnN3aW90bGJfZG1hX29wczsKKwlzd2lv
dGxiID0gMTsKKwlwcmludGsoS0VSTl9JTkZPICJQQ0ktRE1BOiBSZS1pbml0aWFsaXplIG1hY2hp
bmUgdmVjdG9yLlxuIik7CisJbWFjaHZlY19pbml0KCJkaWciKTsKKwlzd2lvdGxiX2luaXQoKTsK
KwlkbWFfb3BzID0gJnN3aW90bGJfZG1hX29wczsKICNlbHNlCi0JCXBhbmljKCJVbmFibGUgdG8g
ZmluZCBJbnRlbCBJT01NVSIpOworCXBhbmljKCJVbmFibGUgdG8gZmluZCBJbnRlbCBJT01NVSIp
OwogI2VuZGlmCi0JfQogfQo=
--000e0cd32c086eb9fb0470ee539e--
