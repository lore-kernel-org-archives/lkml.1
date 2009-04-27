Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZD0LbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZD0LbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZD0LbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:31:13 -0400
Received: from www.tglx.de ([62.245.132.106]:34059 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZD0LbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:31:12 -0400
Date: Mon, 27 Apr 2009 13:30:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [BUG] 2.6.29.1 debugobjects warning
In-Reply-To: <20090424064937.GD21739@elte.hu>
Message-ID: <alpine.LFD.2.00.0904271328530.4529@localhost.localdomain>
References: <20090423140002.GA12852@Krystal> <20090423164638.3b5769c6.akpm@linux-foundation.org> <20090424064937.GD21739@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 23 Apr 2009 10:00:02 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > ODEBUG: init active object type: timer_list
> 
> > It seems to be complaining that cpufreq_governor_dbs() is running 
> > init_timer() against a timer which has already been initialised 
> > once.
> 
> Not just already initialized - but also active. There's these states 
> for an object:
> 
>         ODEBUG_STATE_NONE,
>         ODEBUG_STATE_INIT,
>         ODEBUG_STATE_INACTIVE,
>         ODEBUG_STATE_ACTIVE,
>         ODEBUG_STATE_DESTROYED,
> 
> So the 'init active object type' warning above suggests that an 
> init_timer() has been done on an already running timer. If true then 
> that is a bad bug - can corrupt timer state, etc.
> 
> Thomas, do you agree?

Yes, that kind of bug makes the timer wheel explode later on due to
list corruption.

Thanks,

	tglx

