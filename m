Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYFIW3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYFIW3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761657AbYFIW1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:27:24 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41181 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbYFIW1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:27:23 -0400
Date: Tue, 10 Jun 2008 01:26:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] sound/oss/dmasound/: cleanups
Message-ID: <20080609222628.GW1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly global functions static:
  - dmasound_core.c: get_afmt_string()
  - dmasound_paula.c: dmasound_paula_init()
  - dmasound_q40.c: dmasound_q40_init()
- remove the following unused global variable:
  - dmasound_core.c: software_input_volume

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 sound/oss/dmasound/dmasound_core.c  |    7 +------
 sound/oss/dmasound/dmasound_paula.c |    2 +-
 sound/oss/dmasound/dmasound_q40.c   |    2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

60979b90b9989cbe9553e65622c50018e8d41b15 diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
index a003c0e..95fc5c6 100644
--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -211,10 +211,6 @@ static int state_unit = -1;
 static int irq_installed;
 #endif /* MODULE */
 
-/* software implemented recording volume! */
-uint software_input_volume = SW_INPUT_VOLUME_SCALE * SW_INPUT_VOLUME_DEFAULT;
-EXPORT_SYMBOL(software_input_volume);
-
 /* control over who can modify resources shared between play/record */
 static mode_t shared_resource_owner;
 static int shared_resources_initialised;
@@ -1188,7 +1184,7 @@ static struct {
 
 /* publish this function for use by low-level code, if required */
 
-char *get_afmt_string(int afmt)
+static char *get_afmt_string(int afmt)
 {
         switch(afmt) {
             case AFMT_MU_LAW:
@@ -1551,4 +1547,3 @@ EXPORT_SYMBOL(dmasound_catchRadius);
 EXPORT_SYMBOL(dmasound_ulaw2dma8);
 EXPORT_SYMBOL(dmasound_alaw2dma8);
 #endif
-EXPORT_SYMBOL(get_afmt_string) ;
diff --git a/sound/oss/dmasound/dmasound_paula.c b/sound/oss/dmasound/dmasound_paula.c
index 202e810..06e9e88 100644
--- a/sound/oss/dmasound/dmasound_paula.c
+++ b/sound/oss/dmasound/dmasound_paula.c
@@ -710,7 +710,7 @@ static MACHINE machAmiga = {
 /*** Config & Setup **********************************************************/
 
 
-int __init dmasound_paula_init(void)
+static int __init dmasound_paula_init(void)
 {
 	int err;
 
diff --git a/sound/oss/dmasound/dmasound_q40.c b/sound/oss/dmasound/dmasound_q40.c
index b3379dd..1855b14 100644
--- a/sound/oss/dmasound/dmasound_q40.c
+++ b/sound/oss/dmasound/dmasound_q40.c
@@ -611,7 +611,7 @@ static MACHINE machQ40 = {
 /*** Config & Setup **********************************************************/
 
 
-int __init dmasound_q40_init(void)
+static int __init dmasound_q40_init(void)
 {
 	if (MACH_IS_Q40) {
 	    dmasound.mach = machQ40;

