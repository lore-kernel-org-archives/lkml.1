Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZKJVN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZKJVN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZKJVN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:13:27 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:55712 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZKJVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=W5/HUtkf0sVB+gRwWGfBKZJKlEJycPIuNMZvQKqevzk5xRF4pAdIt8Cazf9fp1BNO7
         fI+62nvvhAs9XwJysX4z8c27+rmvU2AE47EBnHB+d19i4P0YTc/9kseYanVoiqc5gawM
         Vb83bFmB4ak9rLDIxlHvESV2vtZ4aZkV8dvtc=
Message-ID: <4AF9DA42.8060200@gmail.com>
Date: Tue, 10 Nov 2009 22:25:22 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtxxxx/sta_ioctl: rate_index one too large
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`rate_count' is the size of ralinkrate[]. So an index
that equals rate_count is one too large.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/rt2860/sta_ioctl.c |    4 ++--
 drivers/staging/rt3090/sta_ioctl.c |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index c0e0425..5344616 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -2572,8 +2572,8 @@ int rt_ioctl_giwrate(struct net_device *dev,
     if (rate_index < 0)
         rate_index = 0;
 
-    if (rate_index > rate_count)
-        rate_index = rate_count;
+    if (rate_index >= rate_count)
+        rate_index = rate_count - 1;
 
     wrqu->bitrate.value = ralinkrate[rate_index] * 500000;
     wrqu->bitrate.disabled = 0;
diff --git a/drivers/staging/rt3090/sta_ioctl.c b/drivers/staging/rt3090/sta_ioctl.c
index b8ab84a..a314cbb 100644
--- a/drivers/staging/rt3090/sta_ioctl.c
+++ b/drivers/staging/rt3090/sta_ioctl.c
@@ -1409,8 +1409,8 @@ int rt_ioctl_giwscan(struct net_device *dev,
 				int rate_index = 12 + ((UCHAR)capInfo.ChannelWidth * 24) + ((UCHAR)shortGI *48) + ((UCHAR)maxMCS);
 				if (rate_index < 0)
 					rate_index = 0;
-				if (rate_index > rate_count)
-					rate_index = rate_count;
+				if (rate_index >= rate_count)
+					rate_index = rate_count - 1;
 				iwe.u.bitrate.value	=  ralinkrate[rate_index] * 500000;
 			}
 
@@ -3163,8 +3163,8 @@ int rt_ioctl_giwrate(struct net_device *dev,
     if (rate_index < 0)
         rate_index = 0;
 
-    if (rate_index > rate_count)
-        rate_index = rate_count;
+    if (rate_index >= rate_count)
+        rate_index = rate_count - 1;
 
     wrqu->bitrate.value = ralinkrate[rate_index] * 500000;
     wrqu->bitrate.disabled = 0;
@@ -7554,4 +7554,4 @@ INT	Set_Antenna_Proc(
 
 	return TRUE;
 }
-#endif // ANT_DIVERSITY_SUPPORT //
\ No newline at end of file
+#endif // ANT_DIVERSITY_SUPPORT //
