Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbXKDXmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbXKDXmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbXKDXmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:42:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47672 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753110AbXKDXmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:42:12 -0500
Date: Sun, 4 Nov 2007 23:42:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: albertl@mail.com
Cc: albertcc@tw.ibm.com, Tejun Heo <htejun@gmail.com>,
       Daniel Drake <dsd@gentoo.org>, Jeff Garzik <jeff@garzik.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071104234205.7627d007@the-village.bc.nu>
In-Reply-To: <472D445B.1080005@tw.ibm.com>
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
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe we could set a limit here. If the ATAPI device keeps DRQ=1 and
> exceeds the limit, we consider it as HSM violation and have EH handle it.

On a DMA transfer its basically out of our control (and a PIO drain will
lock some controllers solid until power cycle), but on PIO we know we
never set a chunk size over 64K, so if we exceed 64K its time to apply a
larger hammer
