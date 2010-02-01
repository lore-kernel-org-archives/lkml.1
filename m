Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0BAIZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:25:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:45740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab0BAIZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:25:18 -0500
Subject: Re: Lock dependency based tree report in perf lock
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100130185736.GC5675@nowhere>
References: <20100129231723.GB5052@nowhere>
	 <1264841188.24455.54.camel@laptop>  <20100130185736.GC5675@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 09:25:04 +0100
Message-ID: <1265012704.24455.80.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 19:57 +0100, Frederic Weisbecker wrote:
> On Sat, Jan 30, 2010 at 09:46:28AM +0100, Peter Zijlstra wrote:
> > On Sat, 2010-01-30 at 00:17 +0100, Frederic Weisbecker wrote:
> > > 
> > > 
> > > Anyway, that's just an idea, not trivial I must admit.
> > 
> > lockdep actually collects all this information, so writing it out isn't
> > too hard.
> 
> 
> 
> Lockdep collects the theorical dependencies but not the practical
> scenarios.
> 
> Say B and C depend on A, you'll get:
> 
>    A
>   / \
>  B   C
> 
> But nothing can tell you that if A is taken, B and C will always
> be taken. You may have different scenarios based on this dependency,
> which is not something that lockdep logs, right?

Right. But we keep track of the full held lock stack, which is what was
requested.

