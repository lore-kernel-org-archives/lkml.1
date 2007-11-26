Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbXKZO5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbXKZO5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXKZO5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:57:09 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:60548 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbXKZO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:57:08 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 09:57:07 EST
Date: Mon, 26 Nov 2007 06:50:25 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Arne Georg Gleditsch <argggh@dolphinics.no>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Drake <dsd@gentoo.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
In-Reply-To: <kjmpry1mgzs.fsf@pelargir.dolphinics.no>
Message-ID: <Pine.LNX.4.64.0711260631200.21739@twinlark.arctic.org>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
 <20071123012911.3266dba6@the-village.bc.nu> <alpine.DEB.0.99999.0711222206000.32648@twinlark.arctic.org>
 <kjmpry1mgzs.fsf@pelargir.dolphinics.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007, Arne Georg Gleditsch wrote:

> dean gaudet <dean@arctic.org> writes:
> > on AMD x86 pre-family 10h the boundary is 8 bytes, and on fam 10h it's 16 
> > bytes.  the penalty is a mere 3 cycles if an access crosses the specified 
> > boundary.
> 
> Worth noting though, is that atomic accesses that cross cache lines on
> an Opteron system is going to lock down the Hypertransport fabric for
> you during the operation -- which is obviously not so nice.

ooh awesome, i hadn't measured that before.

on a 2 node sockF / revF with a random pointer chase running on cpu 0 / 
node 0 i see the avg load-to-load cache miss latency jump from 77ns to 
109ns when i add an unaligned lock-intensive workload on one core of node 
1.  the worst i can get the pointer chase latency to is 273ns when i add 
two threads on node 1 fighting over an unaligned lock.

on a 4 node (square) the worst case i can get seems to be an increase from 
98ns with no antagonist to 385ns with 6 antagonists fighting over an 
unaligned lock on the other 3 nodes.

cool.

-dean
