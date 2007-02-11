Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbXBKK15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbXBKK15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 05:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXBKK15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 05:27:57 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:35347 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbXBKK14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 05:27:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lgf0KTzgdUjOuy+T8IBmbfzm2FMukiZbEL8LGKR6Vb/QhzbFAj7WvMpXDjzjhwZEsp8WnLlFb7651JWt2rBPn4+3KERWUpbHakHtd9mG/Z3VZFjTKNWmSurmotKVJOglrK8ic0+prt5FXu7Rx/inxLYodf3fPe3B8XQrKvq07zg=
Message-ID: <8d158e1f0702110227i40301348g79db1d8b90f259b1@mail.gmail.com>
Date: Sun, 11 Feb 2007 11:27:54 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: libsata doesn't like bus without master
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Something unrelated to the tests I am doing.

I found out that the libsata driver doesn't really cope or likes the
idea that you might have a controller without a master drive
configured.

In this case on ATA2 I have a CDROM drive, connected as slave.
ATA: abnormal status 0x7F on port 0x177
ATA: abnormal status 0x7F on port 0x177
ata2.01: ATAPI, max UDMA/66
ata2.01: configured for UDMA/66

And in another case, I have ATA5 with no drives connected at all:
pata_pdc2027x 0000:00:0f.0: PLL input clock 33508 kHz
ata5: PATA max UDMA/133 cmd 0xF88597C0 ctl 0xF8859FDA bmdma 0xF8859000 irq 19
ata6: PATA max UDMA/133 cmd 0xF88595C0 ctl 0xF8859DDA bmdma 0xF8859008 irq 19
scsi4 : pata_pdc2027x
ATA: abnormal status 0x8 on port 0xF88597DF


Maybe this is purely a cosmetic error where the error code can be
translated to something like "no drive attached" or maybe the drivers
assume you always configure a master drive on a controller, which
doesnt always have to be the case, especialy not with motherboards
these days where you get 2 ATA ports + 2 exta raid channels.


Patrick
