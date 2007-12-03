Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbXLCXKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbXLCXKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXLCXKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:10:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33294 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751106AbXLCXKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:10:48 -0500
Date: Mon, 3 Dec 2007 23:06:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: solid state drive access and context switching
Message-ID: <20071203230629.725f4c7a@the-village.bc.nu>
In-Reply-To: <47548BF4.3010907@nortel.com>
References: <47548BF4.3010907@nortel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Given a fast low-latency solid state drive, would it ever be beneficial 
> to simply wait in the kernel for synchronous read/write calls to 
> complete?  The idea is that you could avoid at least two task context 
> switches, and if the data access can be completed at less cost than 
> those context switches it could be an overall win.

In certain situations theoretically yes, the kernel is better off
continuing to poll than switching to the idle thread. You can do this to
some extent in a driver already today - just poll rather than sleeping
but respsect the reschedule hints and don't do it with irqs masked.
 
> Has anyone played with this concept?

For things like SATA based devices they aren't that fast yet. 

Alan
