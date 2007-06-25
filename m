Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbXFYXSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbXFYXSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXFYXSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:18:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:50748 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbXFYXSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:18:04 -0400
Date: Mon, 25 Jun 2007 16:17:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: perex@suse.cz, akpm <akpm@linux-foundation.org>
Subject: [PATCH] ALSA: fix ice1712 section mismatch
Message-Id: <20070625161739.8115c40c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Cannot mix const and __initdata:
sound/pci/ice1712/prodigy192.c:708: error: ak4114_controls causes a section type conflict

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pci/ice1712/prodigy192.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22-rc6.orig/sound/pci/ice1712/prodigy192.c
+++ linux-2.6.22-rc6/sound/pci/ice1712/prodigy192.c
@@ -705,7 +705,7 @@ static int ak4114_input_sw_put(struct sn
 }
 
 
-static const struct snd_kcontrol_new ak4114_controls[] __devinitdata = {
+static struct snd_kcontrol_new ak4114_controls[] __devinitdata = {
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 		.name = "MIODIO IEC958 Capture Input",
