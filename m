Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYJFOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYJFOjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYJFOjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:39:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49550 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752664AbYJFOjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:39:01 -0400
Date: Mon, 6 Oct 2008 15:38:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006153825.66e50770@lxorguk.ukuu.org.uk>
In-Reply-To: <20081006072437.5d1360dd@infradead.org>
References: <20081005180154.7cc12486@infradead.org>
	<20081006102739.16d1a434@lxorguk.ukuu.org.uk>
	<48EA1540.8060409@gmail.com>
	<20081006144835.6e58f73a@lxorguk.ukuu.org.uk>
	<20081006065213.76dc729a@infradead.org>
	<20081006150122.3860cae1@lxorguk.ukuu.org.uk>
	<20081006070543.23b14828@infradead.org>
	<20081006151411.05ed5f50@lxorguk.ukuu.org.uk>
	<20081006072437.5d1360dd@infradead.org>
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

> I'll add a "share resource with userland" option to allow us to make
> this desire explicit for the cases we want this (and can tolerate
> concurrent accesses)

For debug tools that would be almost all drivers, and for distribution
use that needs to be a runtime selection.

For the non share-resource-with case what occurs if /dev/mem is active
when the driver is loaded ?

> for me it is a goal to have /dev/mem do as little as possible while
> allowing the "normal" uses. This is to help SELinux to have sane policy
> rather than "X still has perms to own the whole box" etc.

Then it should be runtime configurable

> it came out of chasing e1000e with the "eh who maps our e1000e bar from
> userspace" scare. Followed by thinking "if the driver requests
> exclusivity the kernel should try to grant that".

Only if you can then configure that *policy* decision at runtime in user
space. Otherwise you create shackles that simply harm debug work and make
it harder for distributions to ship the feature enabled by default (which
is the ideal case).

Alan
