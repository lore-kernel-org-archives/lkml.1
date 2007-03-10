Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXCJTHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXCJTHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXCJTHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:07:18 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:53712 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbXCJTHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:07:16 -0500
Date: Sat, 10 Mar 2007 19:05:13 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [SOUND] hda_intel: build fix
Message-ID: <20070310190513.GA24435@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  sound/pci/hda/hda_intel.o
sound/pci/hda/hda_intel.c:1508: error: position_fix_list causes a section type conflict

Gcc like its __devinitdata readable not const, it seems.  An alternative
fix would be to remove the __devinitdata attribute but that would result
in slight runtime bloat.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index b9a8e23..63b6854 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1505,7 +1505,7 @@ static int azx_dev_free(struct snd_device *device)
 /*
  * white/black-listing for position_fix
  */
-static const struct snd_pci_quirk position_fix_list[] __devinitdata = {
+static struct snd_pci_quirk position_fix_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_NONE),
 	{}
 };
