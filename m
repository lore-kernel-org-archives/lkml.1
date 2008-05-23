Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYEWT3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYEWT3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYEWT3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:29:43 -0400
Received: from mail01.fortunecookiestudios.com ([209.208.125.101]:40047 "EHLO
	mail01.fortunecookiestudios.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421AbYEWT3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:29:41 -0400
X-Greylist: delayed 1656 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2008 15:29:41 EDT
From: Andras Mantia <amantia@kde.org>
To: linux-kernel@vger.kernel.org
Subject: libata (pata_via) timeouts causing unusable device: the famous DRDY issue?
Date: Fri, 23 May 2008 22:01:50 +0300
User-Agent: KMail/1.9.51 (Linux/2.6.25.4-2-default; KDE/4.0.80; x86_64; svn-810390; 2008-05-20)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805232201.51701.amantia@kde.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 since my upgrade to openSUSE 11.0, which comes with 2.6.25.4, soon 
after I start using my DVD player, I get the following in the log:

May 23 21:34:04 stein klogd: ata1.00: exception Emask 0x0 SAct 0x0 SErr 
0x0 action 0x2 frozen                                                  
May 23 21:34:04 stein klogd: ata1.00: cmd 
a0/01:00:00:00:08/00:00:00:00:00/a0 tag 0 dma 2048 in                                                
May 23 21:34:04 stein klogd:          cdb 28 00 00 00 01 b3 00 00  01 00 
00 00 00 00 00 00                                                     
May 23 21:34:04 stein klogd:          res 
40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)                                              
May 23 21:34:04 stein klogd: ata1.00: status: { DRDY }                                                                                         
May 23 21:34:04 stein klogd: ata1: soft resetting link                                                                                         
May 23 21:34:04 stein klogd: ata1.00: configured for UDMA/33                                                                                   
May 23 21:34:04 stein klogd: ata1: EH complete                                                                                                 

[...]

May 23 21:52:53 stein klogd: ata1.00: exception Emask 0x0 SAct 0x0 SErr 
0x0 action 0x2 frozen
May 23 21:52:53 stein klogd: ata1.00: cmd 
a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
May 23 21:52:53 stein klogd:          cdb 00 00 00 00 00 00 00 00  00 00 
00 00 00 00 00 00
May 23 21:52:53 stein klogd:          res 
40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
May 23 21:52:53 stein klogd: ata1.00: status: { DRDY }
May 23 21:52:53 stein klogd: ata1: soft resetting link
May 23 21:52:54 stein klogd: ata1.00: configured for PIO0
May 23 21:52:54 stein klogd: ata1: EH complete

and this one repeats until I reboot and the drive becomes unusable. The 
process accessing the drive is stuck and not killable. I also cannot 
eject the drive.


The system is an ASUS A8V Deluxe, with the following controller:
00:0f.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)

The drive is a Lite-On/JLMS dvd reader on first channel as master:
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
ata1.00: ATAPI: JLMS    XJ-HD163, GH5Y, max UDMA/33

It seems to be related to the drive as if I put a Plextor CDRW instead 
of it, I could not see the error. 
Neverthless  looks to be a regression as I could use this drive without 
any problem under openSUSE 10.3, with kernel 2.6.22.17 (and many earlier 
versions as I have this drive for years).

Google gave me lot of hits for similar problem, but no solution. :(

Any hint what I could do (including testing patches) is welcome.

Andras

-- 
 
Quanta Plus developer - http://quanta.kdewebdev.org
K Desktop Environment - http://www.kde.org
