Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbZJLS53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbZJLS53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZJLS52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:57:28 -0400
Received: from www.tglx.de ([62.245.132.106]:57319 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880AbZJLS50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:57:26 -0400
Date: Mon, 12 Oct 2009 20:56:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 0/4] DEBUG_RCU_HEAD: Debug and fix racy call_rcu()
 users
In-Reply-To: <20091012183725.GI17138@elte.hu>
Message-ID: <alpine.LFD.2.00.0910122053540.9428@localhost.localdomain>
References: <20091006143727.868480435@polymtl.ca> <20091012180739.GE17138@elte.hu> <20091012183007.GA12445@Krystal> <20091012183725.GI17138@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Ingo Molnar wrote:
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > Here is a patchset, done on 2.6.30.9, which permits to detect and fix 
> > > > racy call_rcu() users.
> > > 
> > > Nice idea - but any reason why this isnt using the debugojects 
> > > framework? That debugging framework is upstream already and allows this 
> > > kind of object lifetime debugging - in a much broader way.
> > > 
> > 
> > Other than: it did not occur to me, no, there is no reason for not using
> > debugobjects there. :-)
> > 
> > As long as we can tag the object as
> > - initialized
> > - active
> > - inactive
> > 
> > And dump a nice fat warning when the object is activated twice, that
> > should suffice. Now time is a bit short on my side, but I'll keep in
> > mind to respin a version on top of debugobjects soon.

It does, and it also provides you a mechanism to prevent
damage. i.e. you can provide a callback function which can deactivate
an active object before activating it again. That turned out to be
useful for timer wreckage which happened usually way after the
offending code corrupted lists etc.

Thanks,

	tglx
