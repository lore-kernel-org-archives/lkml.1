Return-Path: <linux-kernel-owner+w=401wt.eu-S1765413AbYBTWKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765413AbYBTWKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYBTWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:10:04 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42606 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755346AbYBTWKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:10:01 -0500
Date: Wed, 20 Feb 2008 22:00:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [bug] Re: [PATCH 4/12] riscom8: fix SMP brokenness
Message-ID: <20080220220010.4e439114@core>
In-Reply-To: <47BC8F6C.6040403@garzik.org>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
	<20071023223638.DD9FE1F81A8@havoc.gtf.org>
	<20080207002915.GA27124@elte.hu>
	<47BC8F6C.6040403@garzik.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is unfortunately very low on the priority stack.  I was a bit 
> surprised when it went in, honestly, since I hadn't gotten any "it 
> works" test reports yet...  but that's my fault for not keeping akpm up 
> to date.
> 
> We'll want to revert this for 2.6.25 release, if it doesn't get fixed up.

Fix is trivial: Don't take the lock in rc_release_drivers. The
tty_unregister_driver does its own thing as does put_tty_driver.

Alan
