Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbYHHAb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbYHHAb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYHHAbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:31:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:3064 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbYHHAbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wUCitHK4Bt8m+GwPjts1yoHaF/oPeeAvDqtS5qKwGUMvUSXBdUGCxZwQLCJqIiYdeN
         0dbZP+4dW57vN6TG5hWRU49QpClShkeaRpavHOktDPxPNhZmhfYOwaMepBSOIlr2UcUO
         Cjk0lLeMKvvBoKh1aJIjpt6YSraHKfm/PRZvI=
Message-ID: <489B93F1.50202@gmail.com>
Date: Thu, 07 Aug 2008 17:31:45 -0700
From: Dean Hildebrand <seattleplus@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, dada1@cosmosbay.com
Subject: Re: PCI: Limit VPD length for Broadcom 5708S
References: <aVL4E-5C9-7@gated-at.bofh.it> <2d9716d7-99a4-4d17-9cae-83842e216c8c@y19g2000prn.googlegroups.com> <4898A0B2.3070201@gmail.com> <200808070856.34679.jbarnes@virtuousgeek.org>
In-Reply-To: <200808070856.34679.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jesse Barnes wrote:

> On Tuesday, August 5, 2008 11:49 am Dean Hildebrand wrote:
>>> I have no idea if 5706S and 5709S also needs this truncation ofVPDlength
>> It seems that our IBM Blade servers using 5706S also require this
>> fix.  We have confirmed that the patch below works on 2.6.27-rc1.
>>     
>> diff -uprN linux-2.6.27-rc1/drivers/pci/quirks.c
>> linux-2.6.27-rc1-fix/drivers/pci/quirks.c
>> --- linux-2.6.27-rc1/drivers/pci/quirks.c       2008-08-05
>> 10:51:42.000000000 -0700
>> +++ linux-2.6.27-rc1-fix/drivers/pci/quirks.c   2008-08-05
>> 10:50:57.000000000 -0700
>> @@ -1756,9 +1756,10 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VI
>>    */
>>   static void __devinit quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
>>   {
>> -       /*  Only disable the VPD capability for 5706, 5708, and 5709
>> rev. A */
>> +       /*  Only disable the VPD capability for 5706, 5706S, 5708, and
>> 5709 rev. A */
>>          if ((dev->device == PCI_DEVICE_ID_NX2_5706) ||
>>              (dev->device == PCI_DEVICE_ID_NX2_5708) ||
>> +           (dev->device == PCI_DEVICE_ID_NX2_5706S) ||
>>              ((dev->device == PCI_DEVICE_ID_NX2_5709) &&
>>               (dev->revision & 0xf0) == 0x0)) {
>>                  if (dev->vpd)
> Looks fine.  Can you respin against my for-linus branch and resubmit with a 
> signed-off-by and full changelog
<cid:part1.05050500.03020803@gmail.com>Ok, here it is.
----

BCM5706S wont work correctly unless VPD length truncated to 128

Signed-off-by: Dean Hildebrand <dhildeb@us.ibm.com>
---
 drivers/pci/quirks.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 59667e5..9236e7f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1757,9 +1757,11 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VIA, 
0x324e, quirk_via_cx700_pci_parking_c
 static void __devinit quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
 {
     /*
-     * Only disable the VPD capability for 5706, 5708, 5708S and 5709 
rev. A
+     * Only disable the VPD capability for 5706, 5706S, 5708,
+     * 5708S and 5709 rev. A
      */
     if ((dev->device == PCI_DEVICE_ID_NX2_5706) ||
+        (dev->device == PCI_DEVICE_ID_NX2_5706S) ||
         (dev->device == PCI_DEVICE_ID_NX2_5708) ||
         (dev->device == PCI_DEVICE_ID_NX2_5708S) ||
         ((dev->device == PCI_DEVICE_ID_NX2_5709) &&
-- 
1.5.2.5



