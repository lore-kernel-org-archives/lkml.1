Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbZF2ISH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbZF2ISH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZF2IRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:17:51 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:58000 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZF2IRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:17:50 -0400
Message-ID: <4A4878AC.3050208@turknet.net.tr>
Date: Mon, 29 Jun 2009 11:17:48 +0300
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090625 Shredder/3.0b3pre
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
References: <4A4472DF.1050900@turknet.net.tr> <yq1zlbrn2rj.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1zlbrn2rj.fsf@sermon.lab.mkp.net>
Content-Type: multipart/mixed;
 boundary="------------080808050203080101000305"
X-OriginalArrivalTime: 29 Jun 2009 08:17:51.0140 (UTC) FILETIME=[182EBE40:01C9F892]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080808050203080101000305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/29/2009 06:21 AM, Martin K. Petersen wrote:
> Can you please mail us the output of...
>
> # sg_inq /dev/sdb
> # sg_readcap /dev/sdb
> # sg_readcap -l /dev/sdb
>
> ... for that WD drive?
>
> You may have to install the sg3_utils package.
>
>    

Here are the outputs of sg_* commands. But, I faced a strange behavior 
when I was trying these sg_* commands. Initially, it didn't recognize my 
usb WD disk as I mentioned in my BUG report. Then, after 8 mins, it 
recognized (you can see it on attached "usb.log" file.) it! so, I was 
able to get the outputs of sg_* commands ( Because; when it didn't 
recognize it, there was no "sdb" file under /dev ) and now it works fine!

root@tarkane:~# sg_inq /dev/sdb
standard INQUIRY:
   PQual=0  Device_type=0  RMB=0  version=0x00  [no conformance claimed]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=0
   SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=0  BQue=0
   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
   [SPI: Clocking=0x0  QAS=0  IUS=0]
     length=74 (0x4a)   Peripheral device type: disk
  Vendor identification: WD
  Product identification: 2500JB External
  Product revision level: 0108

root@tarkane:~# sg_readcap /dev/sdb
Read Capacity results:
    Last logical block address=488397167 (0x1d1c596f), Number of 
blocks=488397168
    Logical block length=512 bytes
Hence:
    Device size: 250059350016 bytes, 238475.2 MiB, 250.06 GB


root@tarkane:~# sg_readcap -l /dev/sdb
READ CAPACITY (16) failed [res=-1], try with '-v'


Tarkan


--------------080808050203080101000305
Content-Type: text/plain;
 name="usb.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="usb.log"

Jun 29 10:18:07 tarkane kernel: [160812.883025] usb 5-8: new high speed USB device using ehci_hcd and address 7                                                                                                           
Jun 29 10:18:07 tarkane kernel: [160813.005316] usb 5-8: configuration #1 chosen from 1 choice               
Jun 29 10:18:07 tarkane kernel: [160813.005704] scsi7 : SCSI emulation for USB Mass Storage devices          
Jun 29 10:18:12 tarkane kernel: [160818.046665] scsi 7:0:0:0: Direct-Access     WD       2500JB External  0108 PQ: 0 ANSI: 0                                                                                              
Jun 29 10:18:12 tarkane kernel: [160818.049086] sd 7:0:0:0: Attached scsi generic sg2 type 0                 
Jun 29 10:18:12 tarkane kernel: [160818.050136] sd 7:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)                                                                                                     
Jun 29 10:18:43 tarkane kernel: [160848.805027] usb 5-8: reset high speed USB device using ehci_hcd and address 7                                                                                                         
Jun 29 10:19:14 tarkane kernel: [160879.805023] usb 5-8: reset high speed USB device using ehci_hcd and address 7                                                                                                         
Jun 29 10:19:45 tarkane kernel: [160910.805027] usb 5-8: reset high speed USB device using ehci_hcd and address 7                                                                                                         
Jun 29 10:20:16 tarkane kernel: [160941.805024] usb 5-8: reset high speed USB device using ehci_hcd and address 7                                                                                                         
Jun 29 10:20:47 tarkane kernel: [160972.809028] usb 5-8: reset high speed USB device using ehci_hcd and address 7                                                                                                         
Jun 29 10:21:18 tarkane kernel: [161003.809029] usb 5-8: reset high speed USB device using ehci_hcd and address 7                                                                                                         
Jun 29 10:21:49 tarkane kernel: [161034.809024] usb 5-8: reset high speed USB device using ehci_hcd and address 7                                                                                                         
Jun 29 10:22:20 tarkane kernel: [161065.810022] usb 5-8: reset high speed USB device using ehci_hcd and address 7                                                                                                         
Jun 29 10:22:20 tarkane kernel: [161065.932591] sd 7:0:0:0: [sdb] Write Protect is off                       
Jun 29 10:22:51 tarkane kernel: [161096.808032] usb 5-8: reset high speed USB device using ehci_hcd and address 7
Jun 29 10:23:22 tarkane kernel: [161127.809025] usb 5-8: reset high speed USB device using ehci_hcd and address 7
Jun 29 10:23:53 tarkane kernel: [161158.808037] usb 5-8: reset high speed USB device using ehci_hcd and address 7
Jun 29 10:24:24 tarkane kernel: [161189.809025] usb 5-8: reset high speed USB device using ehci_hcd and address 7
Jun 29 10:24:55 tarkane kernel: [161220.809056] usb 5-8: reset high speed USB device using ehci_hcd and address 7
Jun 29 10:25:26 tarkane kernel: [161251.809043] usb 5-8: reset high speed USB device using ehci_hcd and address 7
Jun 29 10:25:57 tarkane kernel: [161282.809033] usb 5-8: reset high speed USB device using ehci_hcd and address 7
Jun 29 10:26:28 tarkane kernel: [161313.809025] usb 5-8: reset high speed USB device using ehci_hcd and address 7
Jun 29 10:26:28 tarkane kernel: [161313.930904]  sdb: sdb1
Jun 29 10:26:59 tarkane kernel: [161344.809026] usb 5-8: reset high speed USB device using ehci_hcd and address 7


--------------080808050203080101000305--
