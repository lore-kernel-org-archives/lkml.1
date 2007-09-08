Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbXIHW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbXIHW2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 18:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbXIHW2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 18:28:13 -0400
Received: from mail1.bizmail.net.au ([60.246.2.164]:57276 "EHLO
	mail1.bizmail.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbXIHW2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 18:28:12 -0400
Message-ID: <46E32207.6080104@gmail.com>
Date: Sun, 09 Sep 2007 08:28:23 +1000
From: development.jim@gmail.com
Reply-To: development.jim@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.11) Gecko/20050729
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: USB and MMC device problems on Kernel 2.6.22
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for not clear about the kernel version, let me try again:

I have an ARM hardware board works fine with USB and MMC on kernel 
2.6.11. Now, I've just upgraded it to kernel 2.6.22. The modules seem 
loaded fine, please see following list, but neither USB nor MMC could 
detect devices when a USB stick or SD card was plugged in (I enabled 
module debug, but nothing printed out, no device node created in /dev). 
It seems some processes were not running, but I can see usbd and mmcd 
were running at following list, or what is missing?


K22 $ ps
   PID  Uid     VmSize Stat Command
     1 root        268 S   init
     2 root            SW< [kthreadd]
     3 root            SWN [ksoftirqd/0]
     4 root            SW< [events/0]
     5 root            SW< [khelper]
    31 root            SW< [kblockd/0]
    32 root            SW< [ksuspend_usbd]
    35 root            SW< [khubd]
    37 root            SW< [kseriod]
    49 root            SW  [pdflush]
    50 root            SW  [pdflush]
    51 root            SW< [kswapd0]
    52 root            SW< [aio/0]
   638 root            SW< [kapmd]
   670 root            SW< [mtdblockd]
   693 root            SW< [s3c2410-spi.1]
   710 root            SW< [kbd_queue/0]
   746 root            SW< [kmmcd]
   775 root        644 S   /bin/inetd -f
   776 root        404 S   /bin/sh
   790 root        324 R   ps


I understand that the devfs is no longer supported by the kernel 2.6.22, 
but should the modules still be able to detect the devices? I manually 
created nodes on /dev tree such as /dev/mmc /dev/scsi before building 
and downloading to the target. Any clues please?

K22 $ lsmod
Module                  Size  Used by
nls_utf8                1696  0
nls_iso8859_1           3936  0
nls_cp437               5600  0
nls_ascii               3936  0
vfat                   10336  0
fat                    48028  1 vfat
mmc_block               8580  0
s3c2410mci              6560  0
mmc_core               25876  2 mmc_block,s3c2410mci


Thank you.

Jim
