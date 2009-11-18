Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbZKRUhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbZKRUhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbZKRUhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:37:12 -0500
Received: from www.tglx.de ([62.245.132.106]:47277 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbZKRUhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:37:10 -0500
Date: Wed, 18 Nov 2009 21:36:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
In-Reply-To: <20091118175202.490989d8@hyperion.delvare>
Message-ID: <alpine.LFD.2.00.0911182127040.24119@localhost.localdomain>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com> <20091107210147.3e754278@hyperion.delvare> <4AF7148C.9090706@thebigcorporation.com> <20091112211255.09cd884a@hyperion.delvare> <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
 <20091116155606.GC29479@sirena.org.uk> <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com> <20091118010520.4cd397d4@lxorguk.ukuu.org.uk> <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com> <20091118175202.490989d8@hyperion.delvare>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Jean Delvare wrote:

> On Wed, 18 Nov 2009 17:28:53 +0100, Leon Woestenberg wrote:
> > On Wed, Nov 18, 2009 at 2:05 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > Our timers are very efficient and some day we will need to make jiffies a
> > > function and stop the timer ticking for best performance. At that point
> > > timers are probably the most efficient way to do much of this.
> >
> > The problem with I2C bitbanged is the stringent timing, we need a way
> > to have fine-grained sleeping
> > mixed with real-time tasks in order to make this work.
> 
> FWIW, the problem that was initially reported has nothing to do with
> this. i2c-algo-bit used mdelay() during transactions, not yield().
> yield() is used only in once place, _between_ transactions attempts.
> There are no strict timing constraints there.

That still does not explain why yield() is necessary _between_ the
transaction attempts.

That code is fully preemptible, otherwise you could not call
yield(). And as I said before nobody even noticed that the yield()
default implementation was changed to a NOOP by default in the
scheduler.

Thanks,

	tglx
