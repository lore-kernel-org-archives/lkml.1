Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbXKAP5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbXKAP5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbXKAP53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:57:29 -0400
Received: from [81.2.110.250] ([81.2.110.250]:58011 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751389AbXKAP51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:57:27 -0400
Date: Thu, 1 Nov 2007 15:57:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Drake <dsd@gentoo.org>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071101155714.5d1f3b41@the-village.bc.nu>
In-Reply-To: <4729F1BB.20306@gentoo.org>
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
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> "one size" that you can supply to the SG_IO command (unless you want to 
> use a stupidly large buffer) to retrieve all the data at once. Instead, 
> as Tejun describes, you put a short read request in first, look at byte 
> 1 of the page which tells you the length, and then read the whole lot.

ATAPI effectively requires you supply a stupidly large buffer. In theory
you set the transfer size in the lba registers and it all works. In
practice some drives ignore this and there isn't a nice reliable way to
clean up.

Old IDE tries to pio the extra out but that won't work on all controllers
so the wrong combination will still blow up on you.

> Again, ignore me if I'm not contributing anything useful, but I'm 
> increasingly thinking that the SG_IO command block in question is 
> perfectly valid, and doing a short read of the mode page in question 
> (and probably others too) is in fact required before you can know its 
> true size to do a full read anyway.

Welcome to the wonderful world of IDE, where the spec sucks and the
drives manage to do even worse things.

We can try and clean up better in these cases at least for PIO transfers
by trying to drain the data beyond this point, on the controllers that
cope with this but really - fix the app to reflect reality: ATAPI is SCSI
as spoken by yokels

Alan
