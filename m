Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZF1Fx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZF1Fx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 01:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZF1Fxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 01:53:47 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:45014 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbZF1Fxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 01:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=BmQFUWESzLn2vjLqnLjQaa+up813iZPoHeV5+aGl+0CxGRn9I47Qs5vyk/Y57meZJc
         ZJaSztQYNRvuBtYE/qlG7mA+uwFsQLx/bckFF4HKRMs2JUVmDe02XIqLJWimz1BWgpu1
         7yRZozVGMlkGspNUy28dGSky88NwFlHzYfFig=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: linux-hotplug-devel@lists.sourceforge.net
Subject: Kernel 2.6.30 and udevd problem
Date: Sun, 28 Jun 2009 07:53:44 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-ARCH; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906280753.44805.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have recently upgraded my kernel to 2.6.30 and I've noticed that at some 
point (randomly), udevd would start using a lot of CPU time. Killing the 
process and starting it with --debug option prints these messages when the 
problem starts:

[22652] event_queue_insert: seq 168515 queued, 'change' 'drm'
[22657] udev_device_new_from_syspath: device 0x2040320 has devpath 
'/devices/pci0000:00/0000:00:02.0/drm/card0'
[22657] udev_device_read_db: device 0x2040320 filled with db symlink data 
'/dev/dri/card0'
[22657] udev_rules_apply_to_event: LINK 'char/226:0' /lib/udev/rules.d/50-
udev-default.rules:5
[22657] udev_rules_apply_to_event: NAME 'dri/card0' /lib/udev/rules.d/50-udev-
default.rules:38
[22657] udev_rules_apply_to_event: GROUP 91 /lib/udev/rules.d/50-udev-
default.rules:42
[22657] udev_device_new_from_syspath: device 0x2040790 has devpath 
'/devices/pci0000:00/0000:00:02.0'
[22657] udev_device_new_from_syspath: device 0x2040a80 has devpath 
'/devices/pci0000:00'
[22657] udev_rules_apply_to_event: RUN 
'socket:@/org/freedesktop/hal/udev_event' /etc/udev/rules.d/90-hal.rules:2
[22657] udev_device_update_db: create db link (dri/card0 char/226:0)
[22657] udev_node_add: creating device node '/dev/dri/card0', devnum=226:0, 
mode=0660, uid=0, gid=91
[22657] udev_node_mknod: preserve file '/dev/dri/card0', because it has correct 
dev_t
[22657] update_link: '/dev/char/226:0' with target '/dev/dri/card0' has the 
highest priority 0, create it
[22657] node_symlink: preserve already existing symlink '/dev/char/226:0' to 
'../dri/card0'
[22657] udev_monitor_send_device: passed 230 bytes to monitor 0x2040320
[22657] udev_monitor_send_device: passed -1 bytes to monitor 0x2036150
[22657] event_fork: seq 168515 exit with 0
[22652] event_fork: seq 168515 forked, pid [22657], 'change' 'drm', 0 seconds 
old
[22652] udev_done: seq 168515 cleanup, pid [22657], status 0, 0 seconds old

This sequence repeats ad infinitum. I have no clue what it means, so any help 
is appreciated.

My system is a Dell Studio desktop with Intel graphics (G45). I run a standard 
distro kernel (Arch Linux). Please ask me for any other relevant info.

Thanks,
Alberto.
