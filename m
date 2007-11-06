Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbXKFMuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbXKFMuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 07:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbXKFMuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 07:50:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55595 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019AbXKFMuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 07:50:01 -0500
Date: Tue, 6 Nov 2007 12:48:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: albertl@mail.com, albertcc@tw.ibm.com, Daniel Drake <dsd@gentoo.org>,
       Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071106124821.3c7a5ca5@the-village.bc.nu>
In-Reply-To: <47303F77.9080502@gmail.com>
References: <47274A5F.6070409@gentoo.org>
	<20071030153417.59b9182c@the-village.bc.nu>
	<47276DCA.1000808@gentoo.org>
	<20071030190153.373c9347@the-village.bc.nu>
	<47278439.4030801@gentoo.org>
	<20071031114958.210bd7cc@the-village.bc.nu>
	<20071031115754.GK5059@kernel.dk>
	<4729A0DF.20800@garzik.org>
	<20071101105335.1f20bab3@the-village.bc.nu>
	<4729B3EA.6040707@garzik.org>
	<20071101141501.3746cec2@the-village.bc.nu>
	<4729F1BB.20306@gentoo.org>
	<4729F8F1.4040103@gmail.com>
	<472B946F.4030004@gentoo.org>
	<472BCC18.7070503@gmail.com>
	<472CD3F3.7050701@gentoo.org>
	<472D0D4A.70404@gmail.com>
	<472D445B.1080005@tw.ibm.com>
	<20071104234205.7627d007@the-village.bc.nu>
	<472E5E5C.8040308@gmail.com>
	<20071105130330.06a22f7a@the-village.bc.nu>
	<47303F77.9080502@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Just to make sure I'm not misunderstanding it.  So, PDC202xx will lock
> up if you transfer allocation size, reset and then try to drain, but
> it's okay to keep draining as part of continued PIO transfer, right?

The following hang mine:

	PIO transfer
	Reset state machine
	Read data register


	DMA transfer in progress
	Read data register

And this does not

	PIO transfer
	Keep reading data register while checking DRQ

