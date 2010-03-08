Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0CHWAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:00:15 -0500
Received: from proxy.quengel.org ([213.146.113.159]:39778 "EHLO
	gerlin1.hsp-law.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753798Ab0CHWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:00:11 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 17:00:11 EST
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Sound MSI fallout on a Asus mobo NVIDIA MCP55
From: Ralf Gerbig <rge@quengel.org>
Date: Mon, 08 Mar 2010 22:50:08 +0100
Message-ID: <87hboq32lr.fsf@gerlin1.hsp-law.de>
User-Agent: Gnus/5.101 (Gnus v5.10.10) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moins,

without the following patch audio ssttuutteerrs on 

ASUS M2N32-SLI PREMIUM ACPI BIOS Revision 1304

the sound device is: 

00:0e.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)

worked with 2.6.32

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2351,6 +2351,7 @@
 static struct snd_pci_quirk msi_black_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
+	SND_PCI_QUIRK(0x1043, 0x822d, "ASUS", 0), /* Athlon64 X2 + nvidia MCP55*/
 	{}
 };

if you need it: Signed-off-by: Ralf Gerbig <rge@quengel.org>

Ralf
