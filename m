Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYAOVZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYAOVZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYAOVZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:25:27 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:39672 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYAOVZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:25:25 -0500
Date: Tue, 15 Jan 2008 13:24:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-sound@vger.kernel.org
Cc: perex@perex.cz, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH 1/5] sound: fix mts64 section mismatches
Message-Id: <20080115132443.38648a8c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatches in mts64 by making a static variable __devinitdata.

WARNING: vmlinux.o(.data+0x2e33f0): Section mismatch: reference to .init.data:mts64_ctl_smpte_switch (between 'control.19929' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2e33f8): Section mismatch: reference to .init.data:mts64_ctl_smpte_time_hours (between 'control.19929' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2e3400): Section mismatch: reference to .init.data:mts64_ctl_smpte_time_minutes (between 'control.19929' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2e3408): Section mismatch: reference to .init.data:mts64_ctl_smpte_time_seconds (between 'control.19929' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2e3410): Section mismatch: reference to .init.data:mts64_ctl_smpte_time_frames (between 'control.19929' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2e3418): Section mismatch: reference to .init.data:mts64_ctl_smpte_fps (between 'control.19929' and 'snd_mts64_rawmidi_output_ops')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/drivers/mts64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc7-git7.orig/sound/drivers/mts64.c
+++ linux-2.6.24-rc7-git7/sound/drivers/mts64.c
@@ -662,7 +662,7 @@ static int __devinit snd_mts64_ctl_creat
 					  struct mts64 *mts) 
 {
 	int err, i;
-	static struct snd_kcontrol_new *control[] = {
+	static struct snd_kcontrol_new *control[] __devinitdata = {
 		&mts64_ctl_smpte_switch,
 		&mts64_ctl_smpte_time_hours,
 		&mts64_ctl_smpte_time_minutes,
