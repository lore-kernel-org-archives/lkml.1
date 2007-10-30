Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbXJ3PyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbXJ3PyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXJ3PyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:54:05 -0400
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:47042 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXJ3PyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:54:04 -0400
X-Greylist: delayed 2353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 11:54:04 EDT
Message-ID: <47274A5F.6070409@gentoo.org>
Date: Tue, 30 Oct 2007 15:14:39 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: "Fix ATAPI transfer lengths" causes CD writing regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

In 2.6.23 and previous, CD writing works fine on my system. I'm using 
ata_piix on:

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA 
IDE Controller (rev 01)

When I'm running CD writing utilities, I sometimes see this message in 
the kernel logs:
	ata2.00: 66 bytes trailing data
Things do work fine though.

With 2.6.24-rc1, I can't write CDs. Instead of the above message, I get:
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/00:00:00:0a:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 10 in
          res 58/00:02:00:0a:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata2.00: status: { DRDY DRQ }
ata2: soft resetting link
ata2.00: configured for UDMA/33
ata2: EH complete

and the software acts oddly - for example Brasero tells me that the 
blank CD I have inserted has a capacity of 17,179,869,184gb and it 
doesn't let me write CDs as it says the medium is not writable.

git bisect lead me to commit 2db78dd302d26d242d3e8e5c4c5024b6c3ea93c2 as 
the culprit.

Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Tue Oct 2 13:53:04 2007 -0700

     libata_scsi: Fix ATAPI transfer lengths

     Some controller variants snoop the ATAPI length value for Packet
     transfers to do state machine and FIFO management. Thus we want to
     set it properly, even for cases where it is otherwise meaningless.

Any ideas?

Thanks!
Daniel
