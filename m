Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbXEUW1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbXEUW1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbXEUW1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:27:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55380 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758574AbXEUW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:27:14 -0400
Date: Mon, 21 May 2007 15:27:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <Pine.LNX.4.64.0705212026080.5442@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0705211524060.29480@schroedinger.engr.sgi.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com>
 <20070521190043.GA4705@kernel.dk> <Pine.LNX.4.64.0705211208270.27129@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705212026080.5442@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok booting SLUB without "slub_debug" and having

CONFIG_DEBUG_LOCK_ALLOC
CONFIG_LOCKDEP

will trigger the problem.

So I guess the issue is that lockdep does a slab alloc while we get the 
slab lock during slab alloc?

