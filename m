Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYE2PFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYE2PFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYE2PFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:05:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57351 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751751AbYE2PFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:05:04 -0400
Date: Thu, 29 May 2008 15:45:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Cammarata <jimi@sngx.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -
 e1000/pcnet32
Message-ID: <20080529154525.3916c7b5@core>
In-Reply-To: <483EA2D1.8050603@sngx.net>
References: <482DA5B6.1020606@sngx.net>
	<482DB46A.8020103@cosmosbay.com>
	<482EF192.4070707@sngx.net>
	<482F5113.5090703@cosmosbay.com>
	<482F610D.2080108@sngx.net>
	<20080518003104.GK28241@solarflare.com>
	<482FBA09.80201@sngx.net>
	<483E0AAE.2020107@sngx.net>
	<20080528221118.63da4092.akpm@linux-foundation.org>
	<483EA2D1.8050603@sngx.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Many of the kernel's accounting accumulators cannot be reset.  We
> > handle that in userspace tools by using subtraction.
> 
> I don't think that should preclude the ability to reset these, unless it is
> shown that it would break something very badly.

For one quite a few of the network cards keep the stats in hardware and
don't neccessarily have a way to reset them. In other cases there is a
mix of OS accumulated stats bulk updated by overflow events on the device
itself.

Its a lot of complexity, and changes all over the places for the sake of
a trivial userspace change. I would suggest you instead write a quick bit
of perl or python that fetches the stats and then updates every second
with the changes.

Alan
