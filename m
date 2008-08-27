Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYH0Io6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYH0Io6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYH0Ior
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:44:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47042 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753126AbYH0Ioq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:44:46 -0400
Date: Wed, 27 Aug 2008 09:25:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
Message-ID: <20080827092528.780916bd@lxorguk.ukuu.org.uk>
In-Reply-To: <20080826232411.GC11734@cs181140183.pp.htv.fi>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	<48B313E0.1000501@hp.com>
	<alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
	<200808261111.19205.rusty@rustcorp.com.au>
	<alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	<20080826183051.GB10925@cs181140183.pp.htv.fi>
	<alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	<20080826205916.GB11734@cs181140183.pp.htv.fi>
	<alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	<20080826232411.GC11734@cs181140183.pp.htv.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You have a good point that aiming at 4kB makes 8kB a very safe choice.

Not really no - we use separate IRQ stacks in 4K but not 8K mode on
x86-32. That means you've actually got no more space if you are unlucky
with the timing of events. The 8K mode is merely harder to debug.

If 4K stacks really are not safe then x86-32 really really needs to
switch to using IRQ stacks in 8K stack mode as well.

Alan
