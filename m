Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYAIBcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYAIBcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYAIBcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:32:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60604 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752791AbYAIBcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:32:14 -0500
Date: Wed, 9 Jan 2008 01:29:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port
 won't drain
Message-ID: <20080109012947.166e975b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080108160610.53694773.akpm@linux-foundation.org>
References: <20080108115148.GB10546@flint.arm.linux.org.uk>
	<20080108115703.GA27179@flint.arm.linux.org.uk>
	<20080108160610.53694773.akpm@linux-foundation.org>
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

> > Give a port 30ms to drain; this is an arbitary value chosen to avoid
> > long delays if there are many such ports in the system, while giving a
> > reasonable chance for a single port to drain.  Should a port not drain
> > within this timeout, issue a warning.

30mS is a bit short at low baud rates - could we set the timeout based on
baud + fifo size ?

ACK anyway - its clearly better than hanging if hardware flow control has
halted the uart!

