Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbXGCLlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbXGCLlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758969AbXGCLkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:40:51 -0400
Received: from mail1.jogback.se ([192.165.82.16]:49057 "EHLO jogback.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758684AbXGCLku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:40:50 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 07:40:50 EDT
Message-ID: <468A27B8.9000107@swip.net>
Date: Tue, 03 Jul 2007 12:40:56 +0200
From: =?ISO-8859-1?Q?Lars_Michael_Jogb=E4ck?= <lm@swip.net>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with size after growing a device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't know really which subsystem this, so I'm sending this to the 
linux-kernel list.
Please direct me to a more appropriate place if this is not correct.

I'm using a 3ware 9500 with Linux 2.6.18.1. I've grown the HW 
raid5-array and here is where the problem begins. After the card had 
expanded the array, I used "blockdev --rereadpt /dev/sdk" to get the 
kernel to recognize the now larger device. The last step was to do a 
"pvresize /dev/sdk". The problem is that pvresize still thought that the 
device was at the original size.

 From the lvm mailinglist I found out that pvresize used the same 
mechanism as "blockdev --getsz" to get the size of the disks, so I 
tested this and found that blockdev also reported the device to have the 
wrong size.

So, if I do:
# cat /sys/block/sdk/size
4882708480

and
# blockdev --getsz /dev/sdk
3906166784

Apparently /sys/block/sdk/size is updated with the new size, but 
whatever "blockdev --getsz" and "pvresize" is querying is not. If I 
reboot, everything works correctly.

Best Regards,
/LM

Ps. please keep me as Cc: on this; since I'm not subscibed to the 
linux-kernel list..

