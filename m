Return-Path: <linux-kernel-owner+w=401wt.eu-S965297AbXHOXqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297AbXHOXqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964913AbXHOXpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:45:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56042 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762162AbXHOXpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:45:52 -0400
Date: Thu, 16 Aug 2007 00:51:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: do get_rtc_time() correctly
Message-ID: <20070816005151.56176a04@the-village.bc.nu>
In-Reply-To: <46C35284.1080003@reed.com>
References: <46C35284.1080003@reed.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So the proper way to read the RTC contents is to read the UIP flag, and 
> if zero, read all the RTC registers with interrupts masked completely, 
> so all reads happen in the 224 usec window.  (NMI can still be a 
> problem, but you can have NMI's set a flag that forces a retry).

SMM/SMI is more likely to be what bumps you 224usec or more.

> I'm happy to code and test a patch.   Rather than just submit a patch, I 
> thought I'd request others' comments on this, since it affects so many 
> architectures.  cc me, if you will, as I don't subscribe to LKML, just 
> check it periodically.

Go for it. The other architectures generally inherit it by inheriting
similar bridge chips or in more modern times the RTC macrocell. It should
also be possible to debug by putting in an optional sanity check
initially which checks the read made sense compared to a few more
