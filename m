Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYFWJhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYFWJhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYFWJhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:37:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38424 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751274AbYFWJhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:37:05 -0400
Date: Mon, 23 Jun 2008 10:18:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Message-ID: <20080623101840.611cf1b9@lxorguk.ukuu.org.uk>
In-Reply-To: <87wskhuk98.fsf@denkblock.local>
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
	<87wskhuk98.fsf@denkblock.local>
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

> ->polling but not ->resetting should be reset to 0 when
> sil_sata_reset_poll() returns non zero.  So, I now both are 0 once any
> of the poll functions returns ide_stopped.

Historically the polling value was a hack to reduce the size of the
timer/irq/polling races where IRQs end up unmasked again. Resetting
indicated if a reset was currently progressing (in essence 'don't issue
any more resets for the moment'). At the time at least there were cases
where polling=1 resetting=0 could occur (notably DMA crc error handling).

Alan
