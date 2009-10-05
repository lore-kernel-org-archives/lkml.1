Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZJEL1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZJEL1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZJEL1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:27:48 -0400
Received: from relay04-haj2.antispameurope.com ([83.246.65.54]:33950 "EHLO
	relay04-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbZJEL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:27:47 -0400
X-Greylist: delayed 828 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 07:27:47 EDT
Date: Mon, 05 Oct 2009 13:11:51 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: linux-kernel@vger.kernel.org, shawn.starr@rogers.com
Subject: Re: [PROBLEM][2.6.31.1] - Cannot burn DVDs - PIONEER  DVD-RW
  DVR-111D
Message-ID: <4ac9d477.7gleZfWVJq3++UDn%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Oct 2009 11:13:14.0452 (UTC) FILETIME=[D50C3940:01CA45AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Model is: 
>Unable to burn DVDs with 2.6.31.x

>ata7.00: ATAPI: PIONEER DVD-RW  DVR-111D, 1.29, max UDMA/66
>scsi 6:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-111D 1.29 PQ: 0 ANSI: 5

>sr 6:0:0:0: [sr0] Unhandled sense 
>code                                                                                      
>sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK 
>driverbyte=DRIVER_SENSE                                                           
>sr 6:0:0:0: [sr0] Sense Key : Medium Error 
>[current]                                                                        
>Info fld=0x0  
>sr 6:0:0:0: [sr0] Add. Sense: L-EC uncorrectable error
>end_request: I/O error, dev sr0, sector 0
>Buffer I/O error on device sr0, logical block 0

>wodim (cdrecord):

>Errno: 5 (Input/output error), reserve track scsi sendcmd: no error
>CDB:  53 00 00 00 00 00 1D 60 3C 00
>status: 0x2 (CHECK CONDITION)
>Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 00 00 00
>Sense Key: 0x5 Illegal Request, Segment 0
>Sense Code: 0x21 Qual 0x00 (logical block address out of range) Fru 0x0
>Sense flags: Blk 0 (not valid)
>cmd finished after 0.006s timeout 40s
>wodim: Cannot open new session.

Please note that this is not cdrecord but a defective fork where someone
did rip off the working DVD support from the cdrecord original source and 
replaced it with something half baken. Wodim (this is what you used)
does not retrieve information about the medium and this is why it is
very probable that wodim fails when trying to send a SCSi command that is
related to the actual free size on the medium.

It is very likely that this problem does not occur with the original
cdrecord from:

ftp://ftp.berlios.de/pub/cdrecord/alpha/

I've seen similar reports before in the net and reports from users that
reported success after upgrading to the original software.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/private/ ftp://ftp.berlios.de/pub/schily
