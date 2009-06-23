Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbZFWPDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbZFWPDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZFWPDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:03:39 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60560 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZFWPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kUMgjf4kdr08P2raVUFlMbJs3rvlBA/uZ+cViT8NDTWAyl0rR7ZSvB/UHDdWwkN0cu
         inmUKIpZnXRIDjTN4cBxK0bVYeslU0W4IForcDYmIDpx+c4kt+muoBYKYY0aB/uhe/lX
         9HEawISZevS/jBIvXCuWFRCQdOembolK4H7x8=
MIME-Version: 1.0
Date: Tue, 23 Jun 2009 17:03:39 +0200
Message-ID: <8db1092f0906230803s1e069a24w865329c302ffe0df@mail.gmail.com>
Subject: [2.6.30-git17] Touchpad stops working after suspend to disk
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested kernel: 2.6.30-git17
Last known good: 2.6.30

To suspend to disk I use 2 methods, kpowersawe or this script:

#!/bin/sh
governor0=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
governor1=`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor`
f_min_0=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
f_min_1=`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq`
f_max_0=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
f_max_1=`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq`
/sbin/rmmod iwl3945
/sbin/rmmod mac80211
chvt 1
sync
umount /mnt/windows
sleep 1
echo platform > /sys/power/disk
echo -n disk > /sys/power/state
mount /mnt/windows
echo $governor0 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo $governor1 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo $f_min_0 >  /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo $f_min_1 >  /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo $f_max_0 >  /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo $f_max_1 >  /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
/sbin/modprobe mac80211
/sbin/modprobe iwl3945
chvt 1
chvt 7
sleep 5
/etc/init.d/laptop-mode restart
hdparm -B254 /dev/sda

For both resume works without touchpad. I must manualy do:
rmmod psmouse
modprobe psmouse

then works.

How debug it?
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
