Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYGDIag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYGDIag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 04:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYGDIa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 04:30:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47211 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbYGDIa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 04:30:26 -0400
Date: Fri, 4 Jul 2008 09:11:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
Message-ID: <20080704091136.60d81652@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0807032324150.26730@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
	<20080624080744.GL20851@kernel.dk>
	<Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
	<20080625082421.GU20851@kernel.dk>
	<Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com>
	<20080626070723.GL20851@kernel.dk>
	<Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
	<20080702082511.GF20055@kernel.dk>
	<Pine.LNX.4.64.0807031704120.20244@engineering.redhat.com>
	<20080703220449.20688451@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0807031843480.10463@engineering.redhat.com>
	<20080704000010.08db5daf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0807031946580.21723@engineering.redhat.com>
	<20080704004419.25f3c4b2@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0807032324150.26730@engineering.redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That statement is true for any two block device protocol. Then, why 

Not it isn't. The mentality of quite a few devices is very different to
SCSI in the way the express queueing and caching. You cannot for example
map I2O Block onto SCSI at all.

> doesn't Linux use SCSI for all block devices? --- add scsi command block 
> to struct bio and we can pass them directly to controller driver 

That was discussed, along with continuing to split scsi and block aspects
of queueing, tagging and error recovery apart. Windows btw does generally
follow that 'everything is SCSI' approach
