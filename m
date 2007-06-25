Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbXFYVJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbXFYVJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXFYVJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:09:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58923 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbXFYVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:09:28 -0400
Date: Mon, 25 Jun 2007 14:10:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: perex@suse.cz
Subject: [PATCH] ALSA: fix ensoniq section mismatch
Message-Id: <20070625141033.39e382d0.randy.dunlap@oracle.com>
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

Fix ensoniq driver sections when HOTPLUG=n, but code is used
during resume, so it cannot be discarded:
WARNING: sound/pci/snd-ens1371.o(.text+0x5c0): Section mismatch: reference to .init.text: (between 'snd_ensoniq_chip_init' and 'snd_ensoniq_free')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pci/ens1370.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc6.orig/sound/pci/ens1370.c
+++ linux-2.6.22-rc6/sound/pci/ens1370.c
@@ -1607,8 +1607,8 @@ struct es1371_quirk {
 	unsigned char rev;		/* revision */
 };
 
-static int __devinit es1371_quirk_lookup(struct ensoniq *ensoniq,
-					 struct es1371_quirk *list)
+static int es1371_quirk_lookup(struct ensoniq *ensoniq,
+				struct es1371_quirk *list)
 {
 	while (list->vid != (unsigned short)PCI_ANY_ID) {
 		if (ensoniq->pci->vendor == list->vid &&
