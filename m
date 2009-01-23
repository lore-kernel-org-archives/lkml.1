Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZAWQ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZAWQ1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZAWQ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:27:43 -0500
Received: from coding-badger.net ([88.191.17.171]:46014 "EHLO
	sd-1367.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbZAWQ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:27:42 -0500
X-Greylist: delayed 1570 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2009 11:27:42 EST
Message-ID: <4979E9ED.2090402@yahoo.fr>
Date: Fri, 23 Jan 2009 17:01:49 +0100
From: strawks <strawks@yahoo.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1b3pre) Gecko/20081204 Lightning/1.0pre Thunderbird/3.0b1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: USB: lost page write but no error reported on closing raw device
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was trying to copy my entire internal HDD to an USB HDD :
 > dd if=/dev/hda of=/dev/sdb

dd finished without reporting errors but some blocks (around 102GB of 
160) were not copied and I got in the syslog :

Jan 21 19:04:43 kernel: usb 4-2: reset high speed USB device using
ehci_hcd and address 4
Jan 21 19:04:43 kernel: sd 6:0:0:0: [sda] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Jan 21 19:04:43 kernel: end_request: I/O error, dev sda, sector 272136241
Jan 21 19:04:43 kernel: Buffer I/O error on device sda4, logical block
104765468


I don't really know what caused the problem (btw I didn't disconnect the 
USB drive) but the fact is that there were an error copying data to the 
usb drive but this error were not reported to dd.

Is this the expected behaviour? Shouldn't the close() call repports the 
write error to dd?

Note : I tried on debian 2.6.26 stock kernel and 2.6.29-rc2, same behavior.

I have already copied HDD this way (IDE and SCSI but not USB), and each 
time IO errors occured dd would print some error message. I think

-- 
regards
strawks
