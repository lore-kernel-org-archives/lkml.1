Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXFSXKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXFSXKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXFSXKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:10:31 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:15460 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464AbXFSXKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:10:30 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 20 Jun 2007 00:51:20 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 9/12] sound: fix compile error (wrong declaration of
 devinitdata)
Message-ID: <20070619225120.GK5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:50:24.0623 (UTC)
 FILETIME=[393187F0:01C7B2C4]
X-WSS-ID: 6A66825923K845854-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile error:

  CC      sound/pci/ice1712/prodigy192.o
  sound/pci/ice1712/prodigy192.c:708: error: ak4114_controls causes a section type conflict

... but __initdata cannot be "const".

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 sound/pci/ice1712/prodigy192.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/ice1712/prodigy192.c b/sound/pci/ice1712/prodigy192.c
index f03c02c..4bae730 100644
--- a/sound/pci/ice1712/prodigy192.c
+++ b/sound/pci/ice1712/prodigy192.c
@@ -705,7 +705,7 @@ static int ak4114_input_sw_put(struct snd_kcontrol *kcontrol,
 }
 
 
-static const struct snd_kcontrol_new ak4114_controls[] __devinitdata = {
+static struct snd_kcontrol_new ak4114_controls[] __devinitdata = {
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 		.name = "MIODIO IEC958 Capture Input",
-- 
1.5.0.7




