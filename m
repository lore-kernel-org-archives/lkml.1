Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbZD3CHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbZD3CHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 22:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761675AbZD3CHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 22:07:21 -0400
Received: from thunk.org ([69.25.196.29]:38459 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761598AbZD3CHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 22:07:20 -0400
To: linux-kernel@vger.kernel.org
cc: Matthew Wilcox <willy@linux.intel.com>
Subject: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller question)
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1LzLgA-0004j6-9W@closure.thunk.org>
Date: Wed, 29 Apr 2009 22:07:14 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was taking a look at why I can't get NCQ working on the Ultrabay drive
on the X61s Thinkpad (which is a big deal if you're using the X25-M
SSD):

[ 4563.614247] ata4.00: 390721968 sectors, multi 16: LBA48 NCQ (depth 0/32)
                                                                ^^^^^^^

which as near as I can tell is because ATA_FLAG_NCQ isn't set in struct
ata_port->flag.  This looks like it should be set to ata_piix.c if the
controller supports NCQ --- but ata_piix.c doesn't set ATA_FLAG_NCQ at
all.  However, this web page:

	http://www.intel.com/support/chipsets/imst/sb/CS-012304.htm

Seems to imply the 82801HBM/HEM SATA controller from the ICH8M/ICHM8-E
supports AHCI and NCQ, and this is the controller which is in the X61s
laptop.

So I wonder if it's safe to simply add ATA_FLAG_NCQ to ata_piix.c or
not?  Can someone who's more familiar with Intel's ICH8 SATA controller
comment on whether this would be a safe thing to do?

Thanks,

						- Ted
