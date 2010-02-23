Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab0BWIkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:40:10 -0500
Received: from perec.tyrell.hu ([66.197.149.104]:36942 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0BWIkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:40:09 -0500
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2010 03:40:09 EST
Message-ID: <4B839202.8090008@maroy.hu>
Date: Tue, 23 Feb 2010 09:29:54 +0100
From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 8087:0020
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder if this is the write place to post this issue to, but I have a
proplem when trying go suspend or hibernate my system. after enabling
pm_trace by:

echo 1 > /sys/power/pm_trace

and then issuing pm-suspend, I get the following in dmesg:

[  685.833275] PM: Entering mem sleep
[  685.833292] Suspending console(s) (use no_console_suspend to debug)
[  685.993399] pm_op(): usb_dev_suspend+0x0/0x10 returns -2
[  685.993404] PM: Device usb2 failed to suspend: error -2
[  685.993408] PM: Some devices failed to suspend
[  685.997009] PM: resume devices took 0.000 seconds
[  685.997169] PM: Finishing wakeup.

this is on 2.6.32.8, but on 2.6.33-rc8 I get the same results.

trying to find out what device this is:

$ lsusb
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 0bda:0159 Realtek Semiconductor Corp.
Bus 001 Device 004: ID 04f2:b16c Chicony Electronics Co., Ltd
Bus 001 Device 005: ID 03f0:231d Hewlett-Packard
Bus 001 Device 002: ID 8087:0020
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

my persumption is that "Device usb2" would be device 002 on bus 001
above, that is, 8087:0020. googling for this USB id I found some
references here: http://forum.notebookreview.com/showthread.php?p=5906076 :

Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub


I wonder what could be done to make this device not sabotage the suspend
process?


Akos
