Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZAKLnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZAKLnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 06:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZAKLnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 06:43:05 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:46129 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbZAKLnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 06:43:04 -0500
Message-ID: <4969DAF3.70409@pardus.org.tr>
Date: Sun, 11 Jan 2009 13:41:39 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: A really interesting mass-storage BUG introduced after 2.6.18
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One of our users reported[0] that his 128MB mass storage driver doesn't 
work anymore on our current stock kernel 2.6.25.20 by hotplugging but 
works flawlessly if it was plugged before booting the OS. He also said 
that it was working out of the box with our old kernel 2.6.18. I 
gathered a lot of output and debugging stuff from the user[1][2] and 
found out that the device has some problems with SCSI Inquiry commands 
then I discovered the patch of Alan Stern about the bad residue 
values[3], backported it and no way it didn't solve the problem.

I also suggested to give a try to the current stable 2.6.28 but the 
behaviour is still the same.

When hotplugged, the kernel doesn't detect the partitions in the device 
leaving the block device on its own but if it's plugged during the boot, 
the partitions are correctly detected and have their own /sys/block 
entries. Note that the device reports a "usb embedded hub" beside a mass 
storage device (dunno if it's the case with all of these kind devices).

[0]: http://bugs.pardus.org.tr/show_bug.cgi?id=8369
[1]: http://bugzilla.kernel.org/show_bug.cgi?id=11125
[2]: http://bugs.pardus.org.tr/attachment.cgi?id=3553 (Hotplugged dmesg 
output)
[3]: http://bugs.pardus.org.tr/attachment.cgi?id=3561 (Coldplug dmesg 
output, correctly detected)

Regards,

-- 

Ozan Çağlayan
<ozan_at_pardus.org.tr>

