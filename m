Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0BAR6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:58:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:11417 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab0BAR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:58:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oVbj5JsINwMgU4SE+fFNpTfBqdbjob0isqfoXiO1ZsaKB/kZz2V9WUdK95E9u4rh3K
         9fsDhASo6ij33wrPpA7W11q0zH2QdNIQ8PnOPDabQuOX8r8CwF73HtE74UPZsxAZfWMr
         2Hm01ywt8cwGpiRWFsqFB00UE5UAirvGW9QKQ=
Date: Mon, 1 Feb 2010 18:58:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
	analyzing  lock statistics
Message-ID: <20100201175812.GC5241@nowhere>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100129143403.GJ13771@kernel.dk> <4B641F4D.6090704@dcl.info.waseda.ac.jp> <20100131204408.GC13771@kernel.dk> <20100131210707.GF5224@nowhere> <1265015720.24455.101.camel@laptop> <20100201092239.GA22578@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201092239.GA22578@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 10:22:39AM +0100, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sun, 2010-01-31 at 22:07 +0100, Frederic Weisbecker wrote:
> > > 
> > > - We are using the -M option from perf tools which multiplexes every
> > >   event buffers, which means every cpu commit their lock events in
> > >   the same buffer. Couple that with the two above reasons, it's supposed
> > >   to scale at worst.
> > 
> > Why are you doing that? That seems like asking for trouble.. 
> 
> But as i said i already tried with -M off and it didnt cure the slowdown.


Ah.. I've tested the lock events in an atom (two hardware threads) and there
is quite a slowdown too.

Anyway, the patches to remove the string copies from critical lock events
are soon to be ready now. I just suspect there are other problems somewhere
else that cause the slowdown.


> 
> that -M was just copied over from perf sched (where it makes sense).
> 
> 	Ingo



For now it is necessary, because we need the events to be ordered by time,
otherwise the state machine in perf lock would be broken.
We can certainly reorder the events in post-processing, but lock events
tend to grow the file _very_ quickly, so I fear this is going to require
lot of memory. I'll try to find a smart way to fix that.

