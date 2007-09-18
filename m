Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbXIRWTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbXIRWTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbXIRWTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:19:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45223 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754142AbXIRWTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:19:03 -0400
Date: Tue, 18 Sep 2007 23:25:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Message-ID: <20070918232546.004af9ff@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	<20070918113401.6a8a737f@the-village.bc.nu>
	<43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	<alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you use ioport_map/unmap, then you really *should* access them with the 
> proper iomem accessors (ioread/iowrite). The fact that it may happen to 
> work (when using the default lib/iomap.c implementation, at least) on 
> some architectures and with the current implementation still doesn't mean 
> that you should necessarily use readb/writeb.

Another reason we should enforce the use of ioread/iowrite is that some
platforms do daft things like map mmio type devices through indirect
register access. Sparc PCMCIA is a classic example. The only sane way to
make these work is to require ioread/iowrite is used with iomap

