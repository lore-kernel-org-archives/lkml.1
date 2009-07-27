Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZG0DRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZG0DRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 23:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbZG0DRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 23:17:51 -0400
Received: from mail-qy0-f181.google.com ([209.85.221.181]:36203 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbZG0DRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 23:17:50 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jul 2009 23:17:50 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Y9CuXtVsJBUWOBBuH3UDgxiLFIlN/mKBdkPaBzQumJxmwJJGOW7Tw98Z+hj6idRS+d
         W8+Wuv/ez2cPtyT731/4mzl3fg8enmBge2CHuRUWGRDcunzcJbAK050L5wyMDJWWPQU9
         lGOhW7MeS1wurJpLOe8oseYZJRHs3L5rsmX+A=
MIME-Version: 1.0
Date: Mon, 27 Jul 2009 11:10:08 +0800
Message-ID: <2375c9f90907262010s36980f88q28f10b6bc2b5263f@mail.gmail.com>
Subject: Boot panic in 2.6.31-rc4
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a regression in current Linus tree, I can't boot my RHEL5 any more.

I can boot it before 2.6.31, I remember, and also the RHEL5's kernel, of course.
But not since 2.6.31-rc2 or -rc3.

(I used RHEL5's config and did "make oldconfig")

There is a boot panic now, it happened just after loading dm-*
modules, and failed
at not being able to find "/dev/VolGroup00", so I think there is something wrong
with the dm-* modules.

I checked the compiled kernel modules, and found the following difference:

--- /proc/self/fd/11	2009-07-27 10:56:06.975928034 +0800
+++ /proc/self/fd/12	2009-07-27 10:56:06.973928034 +0800
@@ -1,16 +1,13 @@
 kernel/drivers/md/dm-crypt.ko
-kernel/drivers/md/dm-emc.ko
-kernel/drivers/md/dm-hp-sw.ko
+kernel/drivers/md/dm-delay.ko
 kernel/drivers/md/dm-log.ko
-kernel/drivers/md/dm-mem-cache.ko
-kernel/drivers/md/dm-message.ko
 kernel/drivers/md/dm-mirror.ko
 kernel/drivers/md/dm-mod.ko
 kernel/drivers/md/dm-multipath.ko
-kernel/drivers/md/dm-raid45.ko  (<=====Note this one!)
-kernel/drivers/md/dm-rdac.ko
-kernel/drivers/md/dm-region_hash.ko
+kernel/drivers/md/dm-queue-length.ko
+kernel/drivers/md/dm-region-hash.ko
 kernel/drivers/md/dm-round-robin.ko
+kernel/drivers/md/dm-service-time.ko
 kernel/drivers/md/dm-snapshot.ko
 kernel/drivers/md/dm-zero.ko
 kernel/drivers/md/faulty.ko
@@ -20,4 +17,4 @@
 kernel/drivers/md/raid10.ko
 kernel/drivers/md/raid1.ko
 kernel/drivers/md/raid456.ko
-kernel/drivers/md/xor.ko
+kernel/drivers/md/raid6_pq.ko

I also tried to make some aliases for dm-region_hash and dm-raid45, but
that still doesn't work...

Am I missing something here? Can anyone help me out?

Thanks!
