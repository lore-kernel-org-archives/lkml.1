Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbZHMDL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbZHMDL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZHMDL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:11:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:13581 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZHMDL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=r8spRUHo82ILn5b387LSNJZepMe89nnBjVTSl0QXccKzmsala26zTY2z7ooddBufT1
         ikBGKnYjc8UXnfKy0b+gopodVgyXu7llhFdldwozX5Fe409824iSx+FkXKydBUQ7rIhb
         mbWEsRhm6IBjbcfiP+Oat2Ve8z9jCzkqTvmsw=
MIME-Version: 1.0
Date: Thu, 13 Aug 2009 11:11:27 +0800
Message-ID: <3877989d0908122011n27589ff8wfc6d6b50912496c6@mail.gmail.com>
Subject: [RFC patch] clean up swiotlb check in intel_iommu_init
From: Luming Yu <luming.yu@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=000e0cd146569816fb0470fd4ad7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd146569816fb0470fd4ad7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi there,

Since swiotlb is an fall back option that might have
initialized. We don't need to stop intel_iommu_init
because of swiotlb..

Please review. If make sense, please apply.

**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is for review, please apply attached  patch*/

Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

 intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 2314ad7..246acb9 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3194,7 +3194,7 @@ int __init intel_iommu_init(void)
 	 * Check the need for DMA-remapping initialization now.
 	 * Above initialization will also be used by Interrupt-remapping.
 	 */
-	if (no_iommu || (swiotlb && !iommu_pass_through) || dmar_disabled)
+	if (no_iommu || dmar_disabled)
 		return -ENODEV;

 	iommu_init_mempool();

--000e0cd146569816fb0470fd4ad7
Content-Type: application/octet-stream; name=6
Content-Disposition: attachment; filename=6
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fyax5aa60

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL2ludGVsLWlvbW11LmMgYi9kcml2ZXJzL3BjaS9pbnRl
bC1pb21tdS5jCmluZGV4IDIzMTRhZDcuLjI0NmFjYjkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNp
L2ludGVsLWlvbW11LmMKKysrIGIvZHJpdmVycy9wY2kvaW50ZWwtaW9tbXUuYwpAQCAtMzE5NCw3
ICszMTk0LDcgQEAgaW50IF9faW5pdCBpbnRlbF9pb21tdV9pbml0KHZvaWQpCiAJICogQ2hlY2sg
dGhlIG5lZWQgZm9yIERNQS1yZW1hcHBpbmcgaW5pdGlhbGl6YXRpb24gbm93LgogCSAqIEFib3Zl
IGluaXRpYWxpemF0aW9uIHdpbGwgYWxzbyBiZSB1c2VkIGJ5IEludGVycnVwdC1yZW1hcHBpbmcu
CiAJICovCi0JaWYgKG5vX2lvbW11IHx8IChzd2lvdGxiICYmICFpb21tdV9wYXNzX3Rocm91Z2gp
IHx8IGRtYXJfZGlzYWJsZWQpCisJaWYgKG5vX2lvbW11IHx8IGRtYXJfZGlzYWJsZWQpCiAJCXJl
dHVybiAtRU5PREVWOwogCiAJaW9tbXVfaW5pdF9tZW1wb29sKCk7Cg==
--000e0cd146569816fb0470fd4ad7--
