Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYFPSXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYFPSXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYFPSXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:23:31 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:40514 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbYFPSXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:23:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0EAKVIVkhMQW1O/2dsb2JhbACBW6t6
Date: Mon, 16 Jun 2008 14:23:27 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Tom Zanussi <tzanussi@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when
	reading across CPUs.
Message-ID: <20080616182327.GA31477@Krystal>
References: <20080613040958.4f52ee29@linux360.ro> <1213417601.8237.37.camel@charm-linux> <20080614181103.17617db1@linux360.ro> <20080616122249.GB18561@Krystal> <20080616162212.27a8c119@linux360.ro> <20080616164609.GM20851@kernel.dk> <84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:22:08 up 11 days, 23:03,  5 users,  load average: 0.41, 0.81,
	0.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> Hi Jens,
> 
> On Mon, Jun 16 2008, Eduard - Gabriel Munteanu wrote:
> >> In any case, if we use relay in a hot path, we are doing debugging, so
> >> a couple of atomic operations won't be a big problem. Along with
> >> setting affinity, this shouldn't be a problem.
> 
> On Mon, Jun 16, 2008 at 7:46 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > Ehm no, that is a completely false claim. Relay speed does matter, a
> > great deal. We rely heavily on eg blktrace being as ligt weight as
> > possible to capture millions of events in a very short time frame
> > without impacting performance too much. Relay is NOT just for debugging.
> >
> > So I completely agree with Mathieu here, and I'm not a big fan of the
> > proposed solution.
> 
> OK, so we just document that fact that you're not supposed to read
> from different CPU and be done with that? Or do you have any
> alternative fix in mind?
> 

ltt-relay.c in the LTTng project implements its own buffering scheme on
top of relay buffers. It does not have such limitation. Actually, it
does not need to disable interrupts. It uses atomic counters and cmpxchg
atomic ops to manage concurrency. You might want to have a look at it.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
