Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZKNRbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZKNRbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 12:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZKNRbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 12:31:50 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:38861 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbZKNRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 12:31:49 -0500
Message-ID: <4AFEE981.8060505@ahsoftware.de>
Date: Sat, 14 Nov 2009 18:31:45 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
References: <4AFDDDF6.4050907@ahsoftware.de> <4AFDED47.5070606@ahsoftware.de> <4AFE1B0D.3060404@ahsoftware.de> <200911141106.51948.oliver@neukum.org>
In-Reply-To: <200911141106.51948.oliver@neukum.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 14.11.2009 11:06, schrieb Oliver Neukum:
> You can recompile with CONFIG_USB_DEBUG and CONFIG_USB_STORAGE_DEBUG.

Here it comes. I've used 2.6.31.6 and turned usb-(storage-)debug on. 
After mounting the two large encrypted files (loop and dmcrypt) from the 
two connected usb-drives, I've started the rsync -n to compare both 
partitions:

--------------------------------
Nov 14 13:03:41 krabat kernel: [  164.474820] EXT4-fs (dm-1): mounted 
filesystem with ordered data mode
Nov 14 13:04:38 krabat kernel: [  220.963256]  3c da 00 00 10 00
...
(many lines with hex-numbers, nothing else)
...
Nov 14 14:18:49 krabat kernel: [ 4672.953175]  28 00 04 e8 3d da 00 00 
10 00
Nov 14 14:18:49 krabat kernel: [ 4672.960345]  00 f0 00 

Nov 14 14:18:49 krabat kernel: [ 4672.966138]  00 

Nov 14 14:18:50 krabat kernel: [ 4673.071643]  00 04 e8 50 da 00 00 10 
00
Nov 14 14:18:50 krabat kernel: [ 4673.077825]  00 

Nov 14 14:18:50 krabat kernel: [ 4673.077833]  10 00 

Nov 14 14:18:50 krabat kernel: [ 4673.336765]  00 f0 00 

Nov 14 14:18:50 krabat kernel: [ 4673.342205]  28 00 05 3b 40 da 00 00 
10 00
Nov 14 14:18:50 krabat kernel: [ 4673.342230]  00 

Nov 14 14:18:50 krabat kernel: [ 4673.342235] 

Nov 14 14:18:51 krabat kernel: [ 4674.647846]  28 00 05 3c 15 da 00 00 
10 00
Nov 14 14:18:51 krabat kernel: [ 4674.822258] 

Nov 14 14:18:51 krabat kernel: [ 4674.828338]  28 00 04 e9 6e ea 00 00 
f0 00
Nov 14 14:18:57 krabat kernel: [ 4680.042678]  54 da 00 00 10 00 

Nov 14 14:18:59 krabat kernel: [ 4682.646818]  00 05 e2 0c da 00 00 10 
00
Nov 14 14:19:00 krabat kernel: [ 4683.516686]  00 f0 00 

Nov 14 14:19:00 krabat kernel: [ 4683.522288]  28 00 05 e6 9f da 00 00 
10 00
Nov 14 14:19:07 krabat kernel: [ 4690.760331] 

Nov 14 14:19:39 krabat kernel: [ 4722.339214] usb 9-1: reset high speed 
USB device using ehci_hcd and address 4
Nov 14 14:19:39 krabat kernel: [ 4722.591235] usb 9-7: reset high speed 
USB device using ehci_hcd and address 3
Nov 14 14:19:44 krabat kernel: [ 4727.491664] usb 9-1: device firmware 
changed
Nov 14 14:19:44 krabat kernel: [ 4727.491718] usb 9-1: USB disconnect, 
address 4
Nov 14 14:19:44 krabat kernel: [ 4727.493060] scsi 7:0:0:0: Device 
offlined - not ready after error recovery
Nov 14 14:19:44 krabat kernel: [ 4727.493069] scsi 7:0:0:0: [sdc] 
Unhandled error code
Nov 14 14:19:44 krabat kernel: [ 4727.493072] scsi 7:0:0:0: [sdc] 
Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
Nov 14 14:19:44 krabat kernel: [ 4727.493077] end_request: I/O error, 
dev sdc, sector 317945322
Nov 14 14:19:44 krabat kernel: [ 4727.493091] scsi 7:0:0:0: rejecting 
I/O to offline device
Nov 14 14:19:44 krabat kernel: [ 4727.493108] scsi 7:0:0:0: [sdc] 
Unhandled error code
Nov 14 14:19:44 krabat kernel: [ 4727.493110] scsi 7:0:0:0: [sdc] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Nov 14 14:19:44 krabat kernel: [ 4727.493114] end_request: I/O error, 
dev sdc, sector 317945562
Nov 14 14:19:44 krabat kernel: [ 4727.615743] EXT4-fs error (device 
dm-1): ext4_find_entry: reading directory #1771 offset 0
Nov 14 14:19:44 krabat kernel: [ 4727.616071] Buffer I/O error on device 
dm-1, logical block 0
...
(many more io, buffer and ext4 errors)
...
--------------------------------

Regards,

Alexander
