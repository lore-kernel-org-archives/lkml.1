Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbYJHP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbYJHP1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 11:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYJHP1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 11:27:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63151 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbYJHP1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 11:27:11 -0400
Date: Wed, 8 Oct 2008 11:27:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com, srostedt@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
Message-ID: <20081008152708.GA11207@goodmis.org>
References: <20080804130317.994042639@chello.nl> <20080804131012.246115111@chello.nl> <48974512.7000206@goop.org> <1217876046.3589.61.camel@twins> <489757EC.3000309@goop.org> <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 12:31:22PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 4 Aug 2008, Jeremy Fitzhardinge wrote:
> > 
> > OK.  I don't actually need to do this, but I was asking for completeness.  But
> > to clarify, you only need to do the reverse unlock if you do it after
> > unlocking the outer lock?  If you're still holding the outer lock, you can
> > unlock in any order?
> 
> Release order should always be totally irrelevant, whether you hold outer 
> locks or not. Only the order of _getting_ locks matter.

Technically, you are 100% correct.

> 
> And yes, if there is an outer lock, even the order of getting locks is 
> irrelevant, as long as anybody who gets more than one inner lock always 
> holds the outer one.

But I need to disagree on a programming practice style.  Unlocking locks
in a non nested order is just bad programming practice. Unless there is
a good reason to do so, one should never release locks in a non reverse
order they were taken.

This can be a source of bugs, where people might notice an outer lock
being released and think the inner locks were too.

Lately the kernel has been going through a lot of clean ups that have
been making the kernel a much more maintainable beast. I feel we should
enforce the rule of unlocking order (again, unless there is a good
reason not to). Not for a technical reason, but just for a more
maintainable one.

-- Steve

