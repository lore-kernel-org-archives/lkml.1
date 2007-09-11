Return-Path: <linux-kernel-owner+w=401wt.eu-S1751664AbXIKNsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbXIKNsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXIKNsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:48:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41636 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbXIKNsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:48:42 -0400
Date: Tue, 11 Sep 2007 14:56:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matti Linnanvuori <mattilinnanvuori@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Do not deprecate binary semaphore or do allow mutex in software
 interrupt contexts
Message-ID: <20070911145622.0a37bbda@the-village.bc.nu>
In-Reply-To: <20070911153628.26ca02bc@laptopd505.fenrus.org>
References: <11531.17274.qm@web52008.mail.re2.yahoo.com>
	<20070911153628.26ca02bc@laptopd505.fenrus.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> to be honest, the scenario describe really smells of broken locking, in
> fact it really sounds like it wants to use spinlocks instead 

For polling and timer based code its often simpler to do

	del_timer_sync(&my_timer);
	FrobStuff
	add_timer(&my_timer);

especially if "FrobStuff" is likely to change when you next need to poll.

And don't forget regular polling is a good way to really annoy laptop
users as it burns power

Alan

