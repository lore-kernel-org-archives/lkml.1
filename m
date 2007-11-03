Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbXKCUDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbXKCUDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 16:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbXKCUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 16:03:17 -0400
Received: from clarity.mcc.ac.uk ([130.88.200.144]:61082 "EHLO
	clarity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbXKCUDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 16:03:17 -0400
Message-ID: <472CD3F3.7050701@gentoo.org>
Date: Sat, 03 Nov 2007 20:02:59 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org> <20071101141501.3746cec2@the-village.bc.nu> <4729F1BB.20306@gentoo.org> <4729F8F1.4040103@gmail.com> <472B946F.4030004@gentoo.org> <472BCC18.7070503@gmail.com>
In-Reply-To: <472BCC18.7070503@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> <4>ata2.00: HSM violation: eh_analyze_tf: BUSY|DRQ
>> <3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> <3>ata2.00: cmd a0/00:00:00:0a:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data
>> 10 in
>> <4>         res 58/00:02:00:0a:00/00:00:00:00:00/a0 Emask 0x2 (HSM
>> violation)
>> <3>ata2.00: status: { DRDY DRQ }
>> <6>ata2: soft resetting link
>> <6>ata2.00: configured for UDMA/33
>> <6>ata2: EH complete
> 
> Does this patch fix the problem?

That fixes it, thanks! There is no more ugly error in dmesg, the test
prog doesn't print any sense data, and brasero works OK too. However,
these messages appear in the kernel log every time I run the test app
(or when brasero does its thing):

<4>ata2.00: 10 bytes trailing data
<4>ata2.00: 10 bytes trailing data
<4>ata2.00: 10 bytes trailing data
<4>ata2.00: 10 bytes trailing data
<4>ata2.00: 10 bytes trailing data
<4>ata2.00: 10 bytes trailing data
<4>ata2.00: 6 bytes trailing data

Daniel

