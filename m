Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368Ab0AMVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0AMVl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737Ab0AMVl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:41:26 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36816 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0AMVlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:41:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=pMGbmWBAmUhVS3Gq1aae8iQkSVDvE4U/AHU5VSXczSTeoEY7I2yL2ubwFtyNc+Dc+P
         DMIq5S+w8qk2iLhVs3Pd6+fKaRYC/al1+fi2XI18a5a30W7/UVSo1T2RpK71/vLJyyb1
         fwLR7qFQBNJ3jSKa2rrYZcQ0rC3IRKGcPd4Es=
Message-ID: <4B4E3E20.1@googlemail.com>
Date: Wed, 13 Jan 2010 22:41:52 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][CORRECTED] section mismatch:  pcibios_scan_specific_bus()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
pcibios_scan_specific_bus() is only invoked from
__devinit pcibios_fixup_peer_bridges(void).

Mark it as __devinit.
Sry for the first mail, I hadn't sleep enough...

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -39,7 +39,7 @@ static int __init pci_legacy_init(void)
         return 0;
  }

-void pcibios_scan_specific_bus(int busn)
+void __devinit pcibios_scan_specific_bus(int busn)
  {
         int devfn;
         long node;
