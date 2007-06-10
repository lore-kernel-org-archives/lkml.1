Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbXFJPX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbXFJPX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 11:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbXFJPXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 11:23:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40308 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbXFJPXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 11:23:46 -0400
Date: Sun, 10 Jun 2007 16:28:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_it821x: sync with IDE it821x driver
Message-ID: <20070610162859.1d377ea8@the-village.bc.nu>
In-Reply-To: <466B830B.5020007@gmail.com>
References: <200706090223.20933.bzolnier@gmail.com>
	<466A417C.5090901@gmail.com>
	<200706092209.10636.bzolnier@gmail.com>
	<466B830B.5020007@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmm... indeed.  Alan, is there any reason we do that in ->set_piomode
> not ->mode_filter?  We end up with mismatching configuration between the
> controller and the higher speed drive.

We always talk more slowly than the drive which is just fine. Just about
every device on every controller does some variant of this, usually just
for the address setup timings. Our current behaviour (both old and new
IDE) may actually not be conservative enough for register rather than
data timings, which quite possibly should always be at the lower speed.

Currently the PATA drivers use mode_filter to remove modes not allowed
due to hardware issues/flaws/etc and a mix of their own timer merging and
the intelligence in the ata_timing functions to work out what timing
pattern should be used.

Beyond looking further into the register load timings and maybe making
the 8bit timings more conseratively merged (as Sergei I think feels they
should be) I don't plan to change this.

Alan

