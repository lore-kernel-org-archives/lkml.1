Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYAOV1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYAOV1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbYAOV11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:27:27 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:41138 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbYAOV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:27:24 -0500
Date: Tue, 15 Jan 2008 13:25:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-sound@vger.kernel.org
Cc: perex@perex.cz, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH 5/5] sound: fix caiaq section mismatches
Message-Id: <20080115132546.b96de6a2.randy.dunlap@oracle.com>
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

Fix section mismatch in caiaq: these __devinit functions can be
called at any time so they should not be __devinit.

WARNING: vmlinux.o(.text+0x10a8dae): Section mismatch: reference to .init.text:snd_usb_caiaq_audio_init (between 'setup_card' and 'create_card')
WARNING: vmlinux.o(.text+0x10a8dd6): Section mismatch: reference to .init.text:snd_usb_caiaq_midi_init (between 'setup_card' and 'create_card')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/usb/caiaq/caiaq-audio.c |    2 +-
 sound/usb/caiaq/caiaq-midi.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc7-git7.orig/sound/usb/caiaq/caiaq-audio.c
+++ linux-2.6.24-rc7-git7/sound/usb/caiaq/caiaq-audio.c
@@ -606,7 +606,7 @@ static void free_urbs(struct urb **urbs)
 	kfree(urbs);
 }
 
-int __devinit snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *dev)
+int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *dev)
 {
 	int i, ret;
 
--- linux-2.6.24-rc7-git7.orig/sound/usb/caiaq/caiaq-midi.c
+++ linux-2.6.24-rc7-git7/sound/usb/caiaq/caiaq-midi.c
@@ -124,7 +124,7 @@ void snd_usb_caiaq_midi_handle_input(str
 	snd_rawmidi_receive(dev->midi_receive_substream, buf, len);
 }
 
-int __devinit snd_usb_caiaq_midi_init(struct snd_usb_caiaqdev *device)
+int snd_usb_caiaq_midi_init(struct snd_usb_caiaqdev *device)
 {
 	int ret;
 	struct snd_rawmidi *rmidi;
