Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbZAVWb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbZAVWb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZAVWbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:31:20 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:52920 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZAVWbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=jE5EL4oVbmwREQ9Q8hXjTly9FZHpxRJ1D8oKy0uzKXcAlj9g5LEZOKR8XWLJBMPvlX
         P9FMfTWkYq0wofkQ6n+1p7gOlKmIDMoafh7EjAMG370rVn2YHjyOi1xdhkmi+suHVZd1
         JGzDF1+DT+5i/ArmSR1Eso5aXru/rZ/NGV3as=
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 15:31:18 -0700
Message-ID: <96c9d6a80901221431u16dbf135ife7b59f7b38cb8fa@mail.gmail.com>
Subject: Did my SATA drive fail? What should I do?
From: Nathan <nathan.stocks@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First off:  Hi!  I'm new to this list.  Googling some of the errors in
my logs brought up several posts to this list, none of which led to
any obvious resolutions, so I thought I'd try joining the list...

I have a linux server[1] that has been acting as an asterisk pbx for
about three months without a problem.  Today, the SATA hard drive
suddenly went into read-only mode (!?).  Reading seems to work just
fine, as I've ssh'd in and looked at a bunch of files, including
/var/log/messages [2].

Is this just my hardware failing?  Could this a kernel bug?
Recommendations?  I would just reboot the thing, but asterisk is still
successfully handling dozens of calls right now, despite not being
able to write to the disk...

[1] # uname -a
Linux phoneserver3 2.6.25-gentoo-r7 #2 SMP Thu Oct 16 20:59:53 MDT
2008 x86_64 Intel(R) Xeon(R) CPU E5410 @ 2.33GHz GenuineIntel
GNU/Linux

[2] (last several lines from /var/log/messages)

Jan 22 14:43:09 phoneserver3 dhcpd: DHCPDISCOVER from
00:04:f2:1e:7e:21 via eth2: network 10.254.254/24: no free leases
Jan 22 14:43:09 phoneserver3 dhcpd: DHCPDISCOVER from
00:04:f2:1e:7c:6b via eth2: network 10.254.254/24: no free leases
Jan 22 14:43:35 phoneserver3 dhcpd: DHCPDISCOVER from
00:04:f2:1e:0d:47 via eth2: network 10.254.254/24: no free leases
Jan 22 14:43:36 phoneserver3 dhcpd: DHCPDISCOVER from
00:1f:28:83:00:80 via eth2: network 10.254.254/24: no free leases
Jan 22 14:43:41 phoneserver3 ata1.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x0
Jan 22 14:43:41 phoneserver3 ata1.00: BMDMA stat 0x25
Jan 22 14:43:41 phoneserver3 ata1.00: cmd
ca/00:20:00:7c:ef/00:00:00:00:00/ef tag 0 dma 16384 out
Jan 22 14:43:41 phoneserver3 res 51/10:20:00:7c:ef/00:00:00:00:00/ef
Emask 0x81 (invalid argument)
Jan 22 14:43:41 phoneserver3 ata1.00: status: { DRDY ERR }
Jan 22 14:43:41 phoneserver3 ata1.00: error: { IDNF }
Jan 22 14:43:41 phoneserver3 ata1.00: configured for UDMA/133
Jan 22 14:43:41 phoneserver3 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
Jan 22 14:43:41 phoneserver3 sd 0:0:0:0: [sda] Sense Key : Aborted
Command [current] [descriptor]
Jan 22 14:43:41 phoneserver3 Descriptor sense data with sense
descriptors (in hex):
Jan 22 14:43:41 phoneserver3 72 0b 14 00 00 00 00 0c 00 0a 80 00 00 00 00 00
Jan 22 14:43:41 phoneserver3 0f ef 7c 00
Jan 22 14:43:41 phoneserver3 sd 0:0:0:0: [sda] Add. Sense: Recorded
entity not found
Jan 22 14:43:41 phoneserver3 end_request: I/O error, dev sda, sector 267353088
Jan 22 14:43:41 phoneserver3 Buffer I/O error on device sda3, logical
block 33274551
Jan 22 14:43:41 phoneserver3 lost page write due to I/O error on sda3
Jan 22 14:43:41 phoneserver3 Buffer I/O error on device sda3, logical
block 33274552
Jan 22 14:43:41 phoneserver3 lost page write due to I/O error on sda3
Jan 22 14:43:41 phoneserver3 Buffer I/O error on device sda3, logical
block 33274553
Jan 22 14:43:41 phoneserver3 lost page write due to I/O error on sda3
Jan 22 14:43:41 phoneserver3 Buffer I/O error on device sda3, logical
block 33274554
Jan 22 14:43:41 phoneserver3 lost page write due to I/O error on sda3
Jan 22 14:43:41 phoneserver3 ata1: EH complete
Jan 22 14:43:41 phoneserver3 sd 0:0:0:0: [sda] 293046768 512-byte
hardware sectors (150040 MB)
Jan 22 14:43:41 phoneserver3 sd 0:0:0:0: [sda] Write Protect is off
Jan 22 14:43:41 phoneserver3 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 22 14:43:41 phoneserver3 ata1.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x0
Jan 22 14:43:41 phoneserver3 ata1.00: BMDMA stat 0x25
Jan 22 14:43:41 phoneserver3 ata1.00: cmd
ca/00:10:80:ca:12/00:00:00:00:00/e7 tag 0 dma 8192 out
Jan 22 14:43:41 phoneserver3 res 51/10:10:80:ca:12/00:00:00:00:00/e7
Emask 0x81 (invalid argument)
Jan 22 14:43:41 phoneserver3 ata1.00: status: { DRDY ERR }
Jan 22 14:43:41 phoneserver3 ata1.00: error: { IDNF }
