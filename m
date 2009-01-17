Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbZAQPsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbZAQPsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761940AbZAQPsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:48:32 -0500
Received: from mail-ew0-f12.google.com ([209.85.219.12]:56620 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761845AbZAQPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:48:31 -0500
X-Greylist: delayed 2508 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jan 2009 10:48:30 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=OVzCqXNwMoHMIhLNV4H4vi4odxKoBXVj7mKShZYHdvdmb+067ILhiajo8cI2fiBS12
         vZ3s37sOWFB6s/q7JCzMHC+l7vRGQtJIBETmkdQv4Nk5nqnqo3HY1r9ML+fx0ezdVfo9
         /79Ynb8pAJD+DFRDryCovU7L4KJLvIs/31mDg=
Message-ID: <4971FDCC.9090503@gmail.com>
Date: Sat, 17 Jan 2009 16:48:28 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: fix !x & y
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

! has a higher precedence than &

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/meilhaus/me1600_ao.c b/drivers/staging/meilhaus/me1600_ao.c
index d127c6b..9ce0ee9 100644
--- a/drivers/staging/meilhaus/me1600_ao.c
+++ b/drivers/staging/meilhaus/me1600_ao.c
@@ -756,7 +756,7 @@ static int me1600_ao_io_single_write(me_subdevice_t * subdevice,
 	queue_delayed_work(instance->me1600_workqueue,
 			   &instance->ao_control_task, 1);
 
-	if ((!flags & ME_IO_SINGLE_TYPE_WRITE_NONBLOCKING) && ((instance->ao_regs_shadows)->trigger & instance->ao_idx)) {	//Blocking mode. Wait for software trigger.
+	if (!(flags & ME_IO_SINGLE_TYPE_WRITE_NONBLOCKING) && ((instance->ao_regs_shadows)->trigger & instance->ao_idx)) {	//Blocking mode. Wait for software trigger.
 		if (time_out) {
 			delay = (time_out * HZ) / 1000;
 			if (delay == 0)
diff --git a/drivers/staging/meilhaus/me4600_ao.c b/drivers/staging/meilhaus/me4600_ao.c
index e2bec82..2571caf 100644
--- a/drivers/staging/meilhaus/me4600_ao.c
+++ b/drivers/staging/meilhaus/me4600_ao.c
@@ -1025,7 +1025,7 @@ static int me4600_ao_io_stream_config(me_subdevice_t * subdevice,
 	}
 
 	if (flags & ME_IO_STREAM_CONFIG_HARDWARE_ONLY) {
-		if (!flags & ME_IO_STREAM_CONFIG_WRAPAROUND) {
+		if (!(flags & ME_IO_STREAM_CONFIG_WRAPAROUND)) {
 			PERROR
 			    ("Hardware ME_IO_STREAM_CONFIG_HARDWARE_ONLY has to be with ME_IO_STREAM_CONFIG_WRAPAROUND.\n");
 			return ME_ERRNO_INVALID_FLAGS;
diff --git a/drivers/staging/meilhaus/me6000_ao.c b/drivers/staging/meilhaus/me6000_ao.c
index 94f0123..e1c94cb 100644
--- a/drivers/staging/meilhaus/me6000_ao.c
+++ b/drivers/staging/meilhaus/me6000_ao.c
@@ -1063,7 +1063,7 @@ static int me6000_ao_io_stream_config(me_subdevice_t * subdevice,
 	}
 
 	if (flags & ME_IO_STREAM_CONFIG_HARDWARE_ONLY) {
-		if (!flags & ME_IO_STREAM_CONFIG_WRAPAROUND) {
+		if (!(flags & ME_IO_STREAM_CONFIG_WRAPAROUND)) {
 			PERROR
 			    ("Hardware ME_IO_STREAM_CONFIG_HARDWARE_ONLY has to be with ME_IO_STREAM_CONFIG_WRAPAROUND.\n");
 			return ME_ERRNO_INVALID_FLAGS;
diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index 3ea2b2c..2f14840 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -1756,7 +1756,7 @@ int rt_ioctl_siwencode(struct net_device *dev,
             }
         else
 			/* Don't complain if only change the mode */
-			if(!erq->flags & IW_ENCODE_MODE) {
+			if(!(erq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/staging/rt2870/sta_ioctl.c b/drivers/staging/rt2870/sta_ioctl.c
index 91f0fab..2f5bd91 100644
--- a/drivers/staging/rt2870/sta_ioctl.c
+++ b/drivers/staging/rt2870/sta_ioctl.c
@@ -1776,7 +1776,7 @@ int rt_ioctl_siwencode(struct net_device *dev,
             }
         else
 			/* Don't complain if only change the mode */
-			if(!erq->flags & IW_ENCODE_MODE) {
+			if(!(erq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/staging/rt2870/tmp60 b/drivers/staging/rt2870/tmp60
index 975e444..eb50243 100644
--- a/drivers/staging/rt2870/tmp60
+++ b/drivers/staging/rt2870/tmp60
@@ -1776,7 +1776,7 @@ int rt_ioctl_siwencode(struct net_device *dev,
             }
         else
 			/* Don't complain if only change the mode */
-			if(!erq->flags & IW_ENCODE_MODE) {
+			if(!(erq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/staging/rt2870/tmp61 b/drivers/staging/rt2870/tmp61
index 975e444..eb50243 100644
--- a/drivers/staging/rt2870/tmp61
+++ b/drivers/staging/rt2870/tmp61
@@ -1776,7 +1776,7 @@ int rt_ioctl_siwencode(struct net_device *dev,
             }
         else
 			/* Don't complain if only change the mode */
-			if(!erq->flags & IW_ENCODE_MODE) {
+			if(!(erq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 9453495..be4a8a1 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -3161,7 +3161,7 @@ void rtl8180_prepare_beacon(struct net_device *dev)
 		return ;
 
 	}
-	//while(! *tail & (1<<31)){
+	//while(!(*tail & (1<<31))){
 		*tail= 0; // zeroes header
 
 		*tail = *tail| (1<<29) ; //fist segment of the packet
