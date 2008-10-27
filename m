Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYJ0Tur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYJ0Tur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYJ0Tu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:50:26 -0400
Received: from kroah.org ([198.145.64.141]:39763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754285AbYJ0TuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:50:24 -0400
Subject: patch staging-correct-dubious-use-of-x-y.patch added to gregkh-2.6 tree
To: harvey.harrison@gmail.com, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Mon, 27 Oct 2008 12:44:47 -0700
In-Reply-To: <1224646036.5768.8.camel@brick>
Message-ID: <12251366872595@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: correct dubious use of !x & y

to my gregkh-2.6 tree.  Its filename is

    staging-correct-dubious-use-of-x-y.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From harvey.harrison@gmail.com  Mon Oct 27 11:24:51 2008
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Tue, 21 Oct 2008 20:27:16 -0700
Subject: staging: correct dubious use of !x & y
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1224646036.5768.8.camel@brick>


Noticed by sparse:
drivers/staging/me4000/me4000.c:1213:43: warning: dubious: !x & y
drivers/staging/wlan-ng/p80211wext.c:1583:21: warning: dubious: !x & y

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/me4000/me4000.c      |    2 +-
 drivers/staging/wlan-ng/p80211wext.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/me4000/me4000.c
+++ b/drivers/staging/me4000/me4000.c
@@ -1181,7 +1181,7 @@ static int me4000_xilinx_download(struct
 
 	/* Wait until /INIT pin is set */
 	udelay(20);
-	if (!inl(info->plx_regbase + PLX_INTCSR) & 0x20) {
+	if (!(inl(info->plx_regbase + PLX_INTCSR) & 0x20)) {
 		printk(KERN_ERR "%s:Can't init Xilinx\n", __func__);
 		return -EIO;
 	}
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -1580,7 +1580,7 @@ static int p80211wext_set_encodeext(stru
 
 
   if ( ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY ) {
-    if ( ! ext->alg & IW_ENCODE_ALG_WEP) {
+    if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
       WLAN_LOG_DEBUG(1,"asked to set a non wep key :(");
       return -EINVAL;
     }


Patches currently in gregkh-2.6 which might be from harvey.harrison@gmail.com are

staging/staging-correct-dubious-use-of-x-y.patch
