Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbYAVBnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbYAVBnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYAVBnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:43:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33247 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752384AbYAVBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:43:03 -0500
Date: Tue, 22 Jan 2008 01:39:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
Message-ID: <20080122013928.554b52f8@lxorguk.ukuu.org.uk>
In-Reply-To: <200801220231.22609.bzolnier@gmail.com>
References: <200801140019.20668.g.chulkov@jacobs-university.de>
	<20080121164744.2f7d0ed1@lxorguk.ukuu.org.uk>
	<4794D020.4060204@gmail.com>
	<200801220231.22609.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you point me to some bugreports?
> 
> I would like to know more about hosts/conditions for which it happens.

The timer reset path races the I/O path races the interrupt path. That
was the vomitously foul race that persuaded me to go libata instead. I
seem to remember explaining this all some time ago.

The root cause is that we drop the lock on some error paths.
Unfortunately its almost impossible to fix that without having an
infrastructure for quiescing the driver and running a separate error
handling context (the way scsi does).

