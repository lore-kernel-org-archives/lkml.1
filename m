Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZEJVb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZEJVb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbZEJVbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:31:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60323 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753705AbZEJVbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:31:16 -0400
Date: Sun, 10 May 2009 22:29:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org,
       elladan@eskimo.com, npiggin@suse.de, cl@linux-foundation.org,
       minchan.kim@gmail.com
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
 class  citizen
Message-ID: <20090510222938.4d8e0dc3@lxorguk.ukuu.org.uk>
In-Reply-To: <4A073B0D.4090604@redhat.com>
References: <20090430181340.6f07421d.akpm@linux-foundation.org>
	<1241432635.7620.4732.camel@twins>
	<20090507121101.GB20934@localhost>
	<20090507151039.GA2413@cmpxchg.org>
	<20090507134410.0618b308.akpm@linux-foundation.org>
	<20090508081608.GA25117@localhost>
	<20090508125859.210a2a25.akpm@linux-foundation.org>
	<20090508230045.5346bd32@lxorguk.ukuu.org.uk>
	<2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>
	<1241946446.6317.42.camel@laptop>
	<2f11576a0905100236u15d45f7fm32d470776659cfec@mail.gmail.com>
	<20090510144533.167010a9@lxorguk.ukuu.org.uk>
	<4A06EA08.1030102@redhat.com>
	<20090510211350.7aecc8de@lxorguk.ukuu.org.uk>
	<4A073B0D.4090604@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Our big problem today usually isn't throughput though,
> but latency - the time it takes to bring a previously
> inactive application back to life.

But if you page back in in 2MB chunks that is faster too. The initial "oh
dear we guessed wrong and he's clicked on OpenOffice again" we can't
really speed up (barring not paging out those bits and a little bit of
potential gain from not ramming stuff down the disks throat at full pelt)
but the amount of time it takes after that first "run for the disk"
moment is a lot shorter. 

One question I have no idea as to the answer or any research on is "if I
take a 2MB chunk of an apps pages and toss them out together is there
sufficient statistical correlation that makes it useful to pull them back
in together"

Clearly working in 512K/2MB chunks reduces the efficiency that we get
from memory (which we have lots of) as well as improving our I/O
efficiency dramatically (which we are very short of), the question is
which dominates under load.





