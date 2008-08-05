Return-Path: <linux-kernel-owner+w=401wt.eu-S1763092AbYHESth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763092AbYHESth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbYHESta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:49:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:44479 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbYHESt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V6iageaCz/NHEDYFwJPkjGvXnqRAnZh+8gKbz6IZYubJtkFsQTmJ3s2/V19wRDzwPL
         EAid9BDr2LDMvdej233/chBgmAlgYXP8seZSm4mY2MjS5sa99x4oj3yvgPpQe3lUuVq9
         Vk7t5dEGBstmvF9TS4AMq+7rid5uy8UnmKHrU=
Message-ID: <4898A0B2.3070201@gmail.com>
Date: Tue, 05 Aug 2008 11:49:22 -0700
From: Dean Hildebrand <seattleplus@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jbarnes@virtuousgeek.org, dada1@cosmosbay.com
Subject: Re: PCI: Limit VPD length for Broadcom 5708S
References: <aVL4E-5C9-7@gated-at.bofh.it>	<2d9716d7-99a4-4d17-9cae-83842e216c8c@y19g2000prn.googlegroups.com>
In-Reply-To: <2d9716d7-99a4-4d17-9cae-83842e216c8c@y19g2000prn.googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> I have no idea if 5706S and 5709S also needs this truncation ofVPDlength

It seems that our IBM Blade servers using 5706S also require this
fix.  We have confirmed that the patch below works on 2.6.27-rc1.


diff -uprN linux-2.6.27-rc1/drivers/pci/quirks.c 
linux-2.6.27-rc1-fix/drivers/pci/quirks.c
--- linux-2.6.27-rc1/drivers/pci/quirks.c       2008-08-05 
10:51:42.000000000 -0700
+++ linux-2.6.27-rc1-fix/drivers/pci/quirks.c   2008-08-05 
10:50:57.000000000 -0700
@@ -1756,9 +1756,10 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VI
   */
  static void __devinit quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
  {
-       /*  Only disable the VPD capability for 5706, 5708, and 5709 
rev. A */
+       /*  Only disable the VPD capability for 5706, 5706S, 5708, and 
5709 rev. A */
         if ((dev->device == PCI_DEVICE_ID_NX2_5706) ||
             (dev->device == PCI_DEVICE_ID_NX2_5708) ||
+           (dev->device == PCI_DEVICE_ID_NX2_5706S) ||
             ((dev->device == PCI_DEVICE_ID_NX2_5709) &&
              (dev->revision & 0xf0) == 0x0)) {
                 if (dev->vpd)

Please cc me on the response. Thanks,
Dean Hildebrand
IBM Almaden
dhildeb@us.ibm.com

