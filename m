Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbXIZPjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbXIZPjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXIZPjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:39:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:47394 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbXIZPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=QbSFHhjK0Fw8ywLniy/XrY6EGmDoso4H/xm3nmG1B1JzKyr2M5eO5HQFm9IarMn4npmah9BJ2qCtgV+7zxrpGTt8/cypjEgeJxgZtL1uN5QM9D7CypVnvgWLam52ebI+ihDjXi32he6CaHZ8jQTDIGg7yvIJOhGV1DZKQ60cYDk=
Date: Wed, 26 Sep 2007 19:39:01 +0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: venkatesh.pallipadi@intel.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: 2.6.23-rc8-mm1: ata3: soft resetting link after STR
Message-ID: <20070926153901.GA1746@martell.zuzino.mipt.ru>
References: <20070925205006.GA1766@martell.zuzino.mipt.ru> <1190756717.17409.80.camel@chaos> <20070926091412.GA1752@martell.zuzino.mipt.ru> <1190788997.23376.9.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190788997.23376.9.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frequently get these messages after resume from STR,
(subjectively, first STR is always OK).

CONFIG_ATA_PIIX=y is used. CONFIG_IDE=n.

This happened with 2.6.23-rc7-mm1, 2.6.23-rc8-mm1, and
2.6.23-rc7-hrt1.patch

ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: BMDMA stat 0x6
ata3.00: cmd ca/00:08:27:12:72/00:00:00:00:00/eb tag 0 cdb 0x0 data 4096 out
         res 51/84:08:27:12:72/00:00:00:00:00/eb Emask 0x30 (host bus error)
ata3.00: status: {DRDY ERR }
ata3.00: error: {ICRC ABRT }
ata3: soft resetting link
ata3.00: configured for UDMA/133
ata3: EH complete

	[same block several times]

sd 2:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
sd 2:0:0:0: [sdb] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
	72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
	0b 72 12 2f
sd 2:0:0:0: [sdb] ASC=0x47 ASCQ=0x0
end_request: I/O error, dev sdb, sector 192025135
Buffer I/O error on device sdb1
	[same block + 1]
	[same block + 2]
	[same block + 3]
	[same block + 4]
ata3: EH complete
sd 2:0:0:0: [sdb] many 512-byte hardware sectors
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: BMDMA stat 0x6
ata3.00: cmd ca/00:28:67:12:72/00:00:00:00:00/eb tag 0 cdb 0x0 data 20480 out
	...
