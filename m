Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYFPQqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYFPQqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYFPQqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:46:13 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26014 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbYFPQqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:46:13 -0400
Date: Mon, 16 Jun 2008 18:46:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading  across CPUs.
Message-ID: <20080616164609.GM20851@kernel.dk>
References: <20080613040958.4f52ee29@linux360.ro> <1213417601.8237.37.camel@charm-linux> <20080614181103.17617db1@linux360.ro> <20080616122249.GB18561@Krystal> <20080616162212.27a8c119@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616162212.27a8c119@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16 2008, Eduard - Gabriel Munteanu wrote:
> On Mon, 16 Jun 2008 08:22:49 -0400
> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > Hi Eduard,
> 
> Hi.
> 
> > Two objections against this. First, taking a spinlock _is_ slow in SMP
> > because it involves synchronized atomic operations.
> 
> In any case, if we use relay in a hot path, we are doing debugging, so
> a couple of atomic operations won't be a big problem. Along with
> setting affinity, this shouldn't be a problem.

Ehm no, that is a completely false claim. Relay speed does matter, a
great deal. We rely heavily on eg blktrace being as ligt weight as
possible to capture millions of events in a very short time frame
without impacting performance too much. Relay is NOT just for debugging.

So I completely agree with Mathieu here, and I'm not a big fan of the
proposed solution.

-- 
Jens Axboe

