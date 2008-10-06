Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYJFOOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYJFOOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYJFOOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:14:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38447 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752274AbYJFOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:14:15 -0400
Date: Mon, 6 Oct 2008 15:14:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006151411.05ed5f50@lxorguk.ukuu.org.uk>
In-Reply-To: <20081006070543.23b14828@infradead.org>
References: <20081005180154.7cc12486@infradead.org>
	<20081006102739.16d1a434@lxorguk.ukuu.org.uk>
	<48EA1540.8060409@gmail.com>
	<20081006144835.6e58f73a@lxorguk.ukuu.org.uk>
	<20081006065213.76dc729a@infradead.org>
	<20081006150122.3860cae1@lxorguk.ukuu.org.uk>
	<20081006070543.23b14828@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> no argument, except that the kernel doesn't do request_region() on it
> to expect exclusivity (so the patch doesn't do anything on this region)

Its on the TODO list for the vt fixes

> Now having said that, if the DRM layer does request_region on the MMIO
> bars, we might need a flag that explicitly says "this is intended for
> sharing with userspace" for this known case; not too hard, I'll check
> with Dave Airlie.

DRM isn't the problem. In the DRM case the DRM can provide the mappings
and manage them. In the non DRM case its messier but for the moment
probably happens by luck to be ok

I still think your restrictive /dev/mem model is wrong. I think it comes
about because your /dev/mem restrictions are for multiple conflicting
purposes.

The root of that is the 'vaguely annoy root kit writers for 5 minutes'
reasoning which erroneously leads to trying to a compile time option,
combined some would argue with a 'screw people hacking hardware in
userspace who should provide drivers' view.

Now the root kit writer one has minimal credence now as it seems the root
kit writers already adapted. The hardware hacking people have uio
frameworks and should yes be encouraged to use proper drivers.

So there isn't a real reason to make it compile time. Far saner would be
for the /dev/mem restrictions to be flags in sysfs. Even if you stick to
the view about making life harder for rootkit authors then it should be
sysfs restrictions with an irrevocability bit (eg 0 = off 1 = on , 2 = on
(forever))

A flag per feature of this kind then lets you set the different policies
including the highly useful '/dev/mem, I don't think so' policy flag for
server boxes.
