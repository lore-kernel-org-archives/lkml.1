Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbXHPJ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbXHPJ6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXHPJ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:58:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33629 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758690AbXHPJ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:58:03 -0400
Date: Thu, 16 Aug 2007 11:05:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: do get_rtc_time() correctly
Message-ID: <20070816110547.166d96e5@the-village.bc.nu>
In-Reply-To: <46C399C1.9000502@reed.com>
References: <46C35284.1080003@reed.com>
	<20070816005151.56176a04@the-village.bc.nu>
	<46C399C1.9000502@reed.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I understand that SMM/SMI servicing can take a long time, but SMM/SMI 
> shouldn't  happen while interrupts are masked using local_irq_disable() 

Don't bet on it. 

> [included in spin_lock_irq()], at least on x86-architectures.  If 
> SMM/SMI can happen even then, the NMI fix below could be generalized.
> 
> My mention of NMI (which by definition can't be masked) is because NMI 

On x86 you can mask NMI briefly if you are willing to do a bit of CPU
abuse. Force an NMI, longjmp out of the handler, and NMI is off until the
next iret instruction or similar.

We don't do this and I think Linus would object to anyone who did 8)
