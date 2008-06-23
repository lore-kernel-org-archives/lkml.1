Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbYFWUDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbYFWUDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYFWUDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:03:00 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38662 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbYFWUC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:02:59 -0400
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent
	rcutorture less power-hungry
From: Darren Hart <dvhltc@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       josh@freedesktop.org, niv@us.ibm.com, dino@in.ibm.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vegard.nossum@gmail.com, adobriyan@gmail.com, oleg@tv-sign.ru,
       bunk@kernel.org, rjw@sisk.pl
In-Reply-To: <20080623110706.197f25b1@infradead.org>
References: <20080618122144.GA27143@linux.vnet.ibm.com>
	 <20080618162649.GA18326@linux.vnet.ibm.com>
	 <20080622200638.GA25328@linux.vnet.ibm.com>
	 <20080622131712.54ba732c@infradead.org> <1214243649.4440.10.camel@Aeon>
	 <20080623110706.197f25b1@infradead.org>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 20:02:54 +0000
Message-Id: <1214251374.4440.48.camel@Aeon>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 11:07 -0700, Arjan van de Ven wrote:
> On Mon, 23 Jun 2008 17:54:09 +0000
> Darren Hart <dvhltc@us.ibm.com> wrote:
> 
> > I'm a little concerned about how this will affect real-time
> > performance, as queueing up lots of timers all at once can lead to
> > long running timer expiration handlers.  If just a schedule_timeout,
> > I suppose we are only looking at a process wakeup, as opposed to a
> > softirq context callback function?
> 
> in reality, the time it takes to deliver the interrupt (including
> waking the CPU up etc), is likely to be an order or two of magnitude
> higher than this kind of code loop.... 

Sure, if we just look at one of them.  Any idea how many such items
we're looking at rounding up to fire at the same time?  Is it dozens,
hundreds, thousands?

Thanks,

-- 
Darren Hart
Real-Time Linux Team Lead
IBM Linux Technology Center

