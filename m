Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbZL0VX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbZL0VX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZL0VXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:23:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56903 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZL0VXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:23:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=S/MDJpljH0Cf4ooETyUUDbsKYVBmkxtpiAA2aPNtTVVbGMh8e+3aZKCn1T94nE4l0m
         6ak13GH6G4uGwj1iPQ1ai5ilFLxUphodblz0w2+tDGnUVh66oPeZJmpdUL3uqPnhDVay
         tt8sZWl5QBSXWxWU06p/4VCou0W8KrXZiXy4E=
Message-ID: <4B37D117.3000700@gmail.com>
Date: Sun, 27 Dec 2009 22:26:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: test off by one in setsamplerate()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (i++ < MAX_WRITE_RETRY)' i reaches MAX_WRITE_RETRY + 1 after the loop

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 sound/pci/riptide/riptide.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index b5ca02e..e66ef2b 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1058,7 +1058,7 @@ setsamplerate(struct cmdif *cif, unsigned char *intdec, unsigned int rate)
 				 rptr.retwords[2] != M &&
 				 rptr.retwords[3] != N &&
 				 i++ < MAX_WRITE_RETRY);
-			if (i == MAX_WRITE_RETRY) {
+			if (i > MAX_WRITE_RETRY) {
 				snd_printdd("sent samplerate %d: %d failed\n",
 					    *intdec, rate);
 				return -EIO;
