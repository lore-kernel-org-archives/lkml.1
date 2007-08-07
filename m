Return-Path: <linux-kernel-owner+w=401wt.eu-S938104AbXHGWFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938104AbXHGWFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966257AbXHGVlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:41:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51880 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966198AbXHGVlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:41:15 -0400
Date: Tue, 7 Aug 2007 23:41:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [2.6.22.2 review 18/84] Fix sparc32 udelay() rounding errors.
In-Reply-To: <20070807204414.GS23028@kroah.com>
Message-ID: <Pine.LNX.4.64.0708072340330.26397@fbirervta.pbzchgretzou.qr>
References: <20070807204034.882009319@mini.kroah.org> <20070807204414.GS23028@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7 2007 13:44, Greg KH wrote:

>--- a/arch/sparc/kernel/entry.S
>+++ b/arch/sparc/kernel/entry.S
>@@ -1749,8 +1749,8 @@ fpload:
> __ndelay:
> 	save	%sp, -STACKFRAME_SZ, %sp
> 	mov	%i0, %o0
>-	call	.umul
>-	 mov	0x1ad, %o1		! 2**32 / (1 000 000 000 / HZ)
>+	call	.umul			! round multiplier up so large ns ok
>+	 mov	0x1ae, %o1		! 2**32 / (1 000 000 000 / HZ)

If noone noticed - spacing seems odd :)


	Jan
-- 
