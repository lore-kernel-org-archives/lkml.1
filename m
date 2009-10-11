Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZJKKHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZJKKHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 06:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZJKKH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 06:07:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:44006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZJKKH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 06:07:27 -0400
Message-ID: <4AD1AE0D.1030007@kernel.org>
Date: Sun, 11 Oct 2009 03:06:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Brad Spengler <spender@grsecurity.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Boot-time crash from "PCI/x86: detect host bridge config space
 size w/o using quirks"
References: <20091011074531.GA12357@grsecurity.net>
In-Reply-To: <20091011074531.GA12357@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brad Spengler wrote:
> I'm running an SGI 750 (Itanium 1), and have spent all day git-bisecting 
> the patches between 2.6.29 and 2.6.30 (having tried all kernels from 
> 2.6.26 to 2.6.31) and found that your patch:
> http://patchwork.kernel.org/patch/19486/
> causes the crash I observed, which I've taken a picture of here:
> http://yfrog.com/3oimg1457uj
> 
> Let me know if you need any additional information or need me to test a 
> fix you'll submit to LKML.

can you check if this debug patch?

YH

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..4e6a896 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -903,10 +903,6 @@ int pci_cfg_space_size(struct pci_dev *dev)
 	u32 status;
 	u16 class;
 
-	class = dev->class >> 8;
-	if (class == PCI_CLASS_BRIDGE_HOST)
-		return pci_cfg_space_size_ext(dev);
-
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!pos) {
 		pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
