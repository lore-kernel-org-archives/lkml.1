Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYJVD12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYJVD12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYJVD1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:27:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:14037 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYJVD1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=j8Hs/MyjHO+ee+tP+Lqpoz/UvJqH3PmotC3AN0qfRYkkLo9NWK6eNHFXdbcaIQeStw
         jwKdMb8YryUGdV7qj+UZcgGcMq+Tw8XuJwNjUrDbrBxBO6SbCsawcEBW0juHYmjjKhRz
         B2HVwBYJnWdhvYV+SrtYnK8hEHEH26PB9ywrw=
Subject: [PATCH] staging: correct dubious use of !x & y
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 20:27:16 -0700
Message-Id: <1224646036.5768.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse:
drivers/staging/me4000/me4000.c:1213:43: warning: dubious: !x & y
drivers/staging/wlan-ng/p80211wext.c:1583:21: warning: dubious: !x & y

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/staging/me4000/me4000.c      |    2 +-
 drivers/staging/wlan-ng/p80211wext.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
index 862dd7f..182c057 100644
--- a/drivers/staging/me4000/me4000.c
+++ b/drivers/staging/me4000/me4000.c
@@ -1210,7 +1210,7 @@ static int me4000_xilinx_download(me4000_info_t * info)
 
 	/* Wait until /INIT pin is set */
 	udelay(20);
-	if (!inl(info->plx_regbase + PLX_INTCSR) & 0x20) {
+	if (!(inl(info->plx_regbase + PLX_INTCSR) & 0x20)) {
 		printk(KERN_ERR "me4000_xilinx_download():Can't init Xilinx\n");
 		return -EIO;
 	}
diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 906ba43..c42cd7f 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -1580,7 +1580,7 @@ static int p80211wext_set_encodeext(struct net_device *dev,
 

   if ( ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY ) {
-    if ( ! ext->alg & IW_ENCODE_ALG_WEP) {
+    if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
       WLAN_LOG_DEBUG(1,"asked to set a non wep key :(");
       return -EINVAL;
     }
-- 
1.6.0.2.824.geb4d2


