Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYFWJey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYFWJey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYFWJen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:34:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38402 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750942AbYFWJem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:34:42 -0400
Date: Mon, 23 Jun 2008 10:16:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Message-ID: <20080623101600.391e5245@lxorguk.ukuu.org.uk>
In-Reply-To: <87r6apuk16.fsf@denkblock.local>
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
	<87wskhuk98.fsf@denkblock.local>
	<87r6apuk16.fsf@denkblock.local>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> in various ways.  Most importantly, it is treated as an out of band
> request in an illegal way which may very likely lead to system lock ups.
> Use the drive's request queue to avoid this problem (and fix a locking
> issue for free along the way).

It was always designed to be, and used out of band. One of the important
uses of the ioctl is to abort a running command when an interface has
jammed up. If you end up queueing it behind that command you've lost most
of the reason for the ioctl anyway (and you might as well just remove it
really given SG_IO exists).

Other than the command aborting bit, it looks a good idea - that code has
always been racy and raced against timer handlers, irq handlers and if
neither of them got it then a speed changedown raced the lot 8(

Alan
