Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbYCINVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbYCINVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 09:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYCINVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 09:21:22 -0400
Received: from www.tglx.de ([62.245.132.106]:39515 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYCINVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 09:21:22 -0400
Date: Sun, 9 Mar 2008 14:20:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
In-Reply-To: <20080309123432.GA3267@elte.hu>
Message-ID: <alpine.LFD.1.00.0803091407510.3099@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > IMHO we need shrink pgtable cache mecanism.
> > 
> > ouch! Could you try the patch below? How large is the quicklist cache 
> > with this applied?
> 
> hm, Thomas pointed it out that this wont solve all the problems as 
> quicklists have a built-in "preserve me" throttle (which is rather 
> stupid).

There is also the imbalance across CPUs. I think I figured out what's
going there as well. The allocation happens on one CPU (via
page_alloc), but the tear down happens on the other CPU, which
accumulates the pages in the quicklist. So the quicklist of the busy
CPU is empty, while the one of the idle CPU goes up to the limit. When
I pin the loop to one CPU then the quicklists are stable.

Thanks,

	tglx
