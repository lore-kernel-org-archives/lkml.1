Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab0CKNFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:05:46 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:48180 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab0CKNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:05:45 -0500
Subject: RAID + LUKS + LVM performance
X-KeepSent: 8365E100:57191C87-802576E3:0046BDEA;
 type=4; name=$KeepSent
To: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.0.2 HF623 January 16, 2009
Message-ID: <OF8365E100.57191C87-ON802576E3.0046BDEA-802576E3.0047EFDF@ie.ibm.com>
From: Mathias Buren <mathias.buren@ie.ibm.com>
Date: Thu, 11 Mar 2010 13:08:56 +0000
X-MIMETrack: Serialize by Router on D06ML902/06/M/IBM(Release 8.0.1|February 07, 2008) at
 11/03/2010 13:08:58
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

(please cc me as I'm not subscribed)

I've a friend who's going to set up a fileserver consisting of 8x 1.5TB
HDDs, an 8-port PCI-E RAID card (Areca ARC-1220 @
http://www.areca.com.tw/products/pcie.htm ) etc.
The plan is create a RAID5 array spanning all the disks, then create 4
partitions. These 4 partitions would be encrypted using LUKS (Twofish or
AES256).
These 4 encrypted partition would be set up in RAID0 using Linux' software
(mdadm), then LVM would be used on top of that (one big PV, one big VG and
a big LV or so).

The reason for this is that kcryptd is not multithreaded (afaik). By having
4 encrypted partitions, then md0 on top of them, I'm forcing 4 kcryptd
processes to run on all four cpu cores whenever something is written to the
disks, which should improve (encryption) performance.

Is this a good way of doing it, or is there a smarter way?


Regards,

Mathias,

