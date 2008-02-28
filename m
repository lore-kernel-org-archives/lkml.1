Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbYB1TL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbYB1TL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYB1TLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:11:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:19675 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbYB1TLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cSohejk6DRErNbwupKe8PUCQ3pJ1gd0+d2VKuJOdbNZ2QSeG59jd4UCkZGHKtrCgOFC8WUojODQEi6ZyvNjMfl9n6qgUF9L/v4meaS0J7QdUs+APRgut6wEEZVyI8Rs8tJcoEqTCmiOk8lwh0/LKKUWUy9HGKxRX5ng6oFD6KUY=
Subject: [PATCH 1/8] sound: emuproc.c fix signedness warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:11:12 -0800
Message-Id: <1204225872.20280.79.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading regs from the fpga into an int instead of a u32, trivial
fix.
sound/pci/emu10k1/emuproc.c:422:34: warning: incorrect type in argument 3 (different signedness)
sound/pci/emu10k1/emuproc.c:422:34:    expected unsigned int [usertype] *value
sound/pci/emu10k1/emuproc.c:422:34:    got int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/emu10k1/emuproc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/emu10k1/emuproc.c b/sound/pci/emu10k1/emuproc.c
index f3caa3f..216f974 100644
--- a/sound/pci/emu10k1/emuproc.c
+++ b/sound/pci/emu10k1/emuproc.c
@@ -412,7 +412,7 @@ static void snd_emu_proc_emu1010_reg_read(struct snd_info_entry *entry,
 				     struct snd_info_buffer *buffer)
 {
 	struct snd_emu10k1 *emu = entry->private_data;
-	int value;
+	u32 value;
 	unsigned long flags;
 	int i;
 	snd_iprintf(buffer, "EMU1010 Registers:\n\n");
-- 
1.5.4.3.342.g99e8


