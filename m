Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbXG2RrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbXG2RrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763929AbXG2RrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:47:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59835 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759559AbXG2RrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:47:01 -0400
Date: Sun, 29 Jul 2007 18:53:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, david@lang.hm,
       Daniel Hazelton <dhazelton@enter.net>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
Message-ID: <20070729185317.5a5f1c30@the-village.bc.nu>
In-Reply-To: <46ACCF7A.1080207@gmail.com>
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	<46AC4B97.5050708@gmail.com>
	<20070729141215.08973d54@the-village.bc.nu>
	<46AC9F2C.8090601@gmail.com>
	<2c0942db0707290758p39fef2e8o68d67bec5c7ba6ab@mail.gmail.com>
	<46ACAB45.6080307@gmail.com>
	<2c0942db0707290820r2e31f40flb51a43846169a752@mail.gmail.com>
	<46ACB40C.2040908@gmail.com>
	<2c0942db0707290904n4356582dt91ab96b77db1e84e@mail.gmail.com>
	<46ACC76A.3080303@gmail.com>
	<2c0942db0707291019q14f309d0jab3bf083aa37d707@mail.gmail.com>
	<46ACCF7A.1080207@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is that generally the case on your systems? Every linux system I've
> > run, regardless of RAM, has always pushed things out to swap.
> 
> For me, it is generally the case yes. We are still discussing this in the 
> context of desktop machines and their problems with being slow as things 
> have been swapped out and generally I expect a desktop to have plenty of 
> swap which it's not regularly going to fillup significantly since then the 
> machine's unworkably slow as a desktop anyway.

A simple log optimises writeout (which is latency critical) and can
otherwise stall an enitre system. In a log you can also have multiple
copies of the same page on disk easily, some stale - so you can write out
chunks of data that are not all them removed from memory, just so you get
them back more easily if you then do (and I guess you'd mark them
accordingly)

The second element is a cleaner - something to go around removing stuff
from the log that is needed when the disks are idle - and also to repack
data in nice linear chunks. So instead of using the empty disk time for
page-in you use it for packing data and optimising future paging.

