Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZAKAMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZAKAMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZAKAMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:12:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48996 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752900AbZAKAME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:12:04 -0500
Date: Sun, 11 Jan 2009 00:10:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] Re: todays git: WARNING: at
 drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090111001038.33943d2e@lxorguk.ukuu.org.uk>
In-Reply-To: <4968FFD7.6070302@ru.mvista.com>
References: <200901091334.55823.borntraeger@de.ibm.com>
	<200901101009.13699.borntraeger@de.ibm.com>
	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>
	<200901101242.05203.borntraeger@de.ibm.com>
	<49688B63.5030105@ru.mvista.com>
	<20090110122130.318cf168@lxorguk.ukuu.org.uk>
	<20090110130745.GA14049@elte.hu>
	<49689EA8.20506@garzik.org>
	<20090110132412.GB14049@elte.hu>
	<20090110133617.GA22304@elte.hu>
	<20090110135731.0da08c90@lxorguk.ukuu.org.uk>
	<4968BA6F.8050207@ru.mvista.com>
	<20090110152800.44308491@lxorguk.ukuu.org.uk>
	<4968C5CA.6010508@ru.mvista.com>
	<4968FFD7.6070302@ru.mvista.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>     data_xfer transfers 18 bytes + 2 padding (correctly) -> 20 bytes
> 
>    Correctly indeed? I'm not at all sure it's correct to read an extra 
> 16-bit word off the device when it thinks it's already done with the 
> data transfer.

The VLB controller docs explicitly require you do entirely 32bit. The AMD
ones seem to imply you should.

Its easy enough to not do that but for the VLB case we have to so the
WARN needs fixing which ever path we go down.
