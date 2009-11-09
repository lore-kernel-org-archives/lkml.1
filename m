Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZKIPeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZKIPeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbZKIPeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:34:15 -0500
Received: from [95.166.99.235] ([95.166.99.235]:40397 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756357AbZKIPeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:34:14 -0500
Date: Mon, 9 Nov 2009 16:34:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
Message-ID: <20091109153418.GX8742@kernel.dk>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu> <20091106095922.GH8742@kernel.dk> <20091108093859.GA2845@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108093859.GA2845@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, Nov 06 2009, Ingo Molnar wrote:
> > > Read the lockdep message please, consider all the backtraces it prints, 
> > > it says something different.
> > 
> > In all honesty, reading and parsing lockdep messages requires a 
> > special state of mind. IOW, readability is not its high point.
> 
> We frequently do patches to improve the messages but there's a hard 
> limit: generally the messages mirror the complexity of the underlying 
> locking scenario.
> 
> Unfortunately lockdep cannot pretend something is simple when it is not. 
> There are two ways out of that: either to simplify the underlying 
> locking rules, or to understand them.

I think the primary problem is that it tries to condense too much
information, instead of just spelling it out. That may be obvious to a
person intimately familiar with lockdep, but not to others. Things like
the STATE line, for instance. It would read a lot easier if these things
were just spelled out.

I know this message isn't really productive, just tossing it out there.
I'll try to to back it up with a patch the next time it annoys me :-)

-- 
Jens Axboe

