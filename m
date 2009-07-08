Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZGHOa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZGHOa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZGHOas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:30:48 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:38118 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbZGHOas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:30:48 -0400
Date: Wed, 08 Jul 2009 15:29:49 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: alsa-devel@alsa-project.org, tiwai@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.31-rc2] Missing volume controls for Intel HDA (ALC269/EeePC)
Message-ID: <507D1B5CC4%linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: alsa-devel@alsa-project.org, tiwai@suse.de, 
 linux-kernel@vger.kernel.org, Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.58.5.3087 (Qt/4.5.1) (Linux-x86_64)
X-NuLabour-Date: Wed, 8986 Dec 1984 15:29:49 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a regression, introduced in aa202455eec51699e44f658530728162cefa1307
(in alsa-kernel) which I noticed when trying to use the headphone socket on
my EeeCPC 901: the output was *very* quiet, practically silent.

This patch corrects the control types to that which was obviously intended in
the referenced commit.

Signed-Off-By: Darren Salt <linux@youmustbejoking.demon.co.uk>

--- a/sound/pci/hda/patch_realtek.c	2009-07-05 17:30:41.000000000 +0100
+++ b/sound/pci/hda/patch_realtek.c	2009-07-08 14:50:38.000000000 +0100
@@ -12878,9 +12878,9 @@
 
 static struct snd_kcontrol_new alc269_eeepc_mixer[] = {
 	HDA_CODEC_MUTE("Speaker Playback Switch", 0x14, 0x0, HDA_OUTPUT),
-	HDA_CODEC_MUTE("Speaker Playback Volume", 0x02, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Speaker Playback Volume", 0x02, 0x0, HDA_OUTPUT),
 	HDA_CODEC_MUTE("Headphone Playback Switch", 0x15, 0x0, HDA_OUTPUT),
-	HDA_CODEC_MUTE("Headphone Playback Volume", 0x03, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Headphone Playback Volume", 0x03, 0x0, HDA_OUTPUT),
 	{ } /* end */
 };
 

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
|   <URL:http://www.youmustbejoking.demon.co.uk/progs.packages.html>

I have one illusion, and that's that I have no illusions.
