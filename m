Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYIEFkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYIEFkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 01:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYIEFjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 01:39:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:35792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbYIEFjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 01:39:52 -0400
Date: Thu, 4 Sep 2008 22:39:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, netdev@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: linux-next: Tree for September 3
Message-ID: <20080904223939.18a166aa@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0809041554050.3117@nehalem.linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>
	<20080903223318.84b6ce8b.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040045190.3378@nehalem.linux-foundation.org>
	<20080904012544.cabed847.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040143350.3452@nehalem.linux-foundation.org>
	<20080904015701.5959623a.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040203510.3452@nehalem.linux-foundation.org>
	<20080904104554.32ffebea.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809041058140.3400@nehalem.linux-foundation.org>
	<20080904113408.d47c65f6.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809050041520.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809041554050.3117@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 16:17:01 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 5 Sep 2008, Thomas Gleixner wrote:
> >  
> > > BUG: unable to handle kernel NULL pointer dereference at 00000040
> > > IP: [<c0126e7f>] get_next_timer_interrupt+0xe9/0x1ab
> > 
> > Cute, NULL pointer in the timer check code. Can you please addr2line
> > the exact code line or upload the vmlinux somewhere ?
> 
> Use "scrips/decodecode" (with AFLAGS=--32 since this is x86-32). It
> shows (after some cleanup and editing):


btw if the oops was on lkml like it was here you can also just look it
up on kerneloops.org via the search option

which for this case finds you
http://www.kerneloops.org/raw.php?rawid=59347&msgid=http://mid.gmane.org/20080904113408.d47c65f6.akpm@linux-foundation.org

and this has the decodecode already done 

and the search output at
http://www.kerneloops.org/search.php?search=get_next_timer_interrupt
shows that there's only been very few reports of this one, but of the
ones there were at least half were slab poisoned.

what the site doesn't do for an oops like this is show the C-code
interspersed, it's not that smart for general kernels (that only works
for fedora rpm kernels like here:
http://www.kerneloops.org/raw.php?rawid=57807&msgid=
)

otoh if you have the vmlinux you could do this locally
(hmm maybe I should clean that script up and submit for adding to
the scripts/ directory)
-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
