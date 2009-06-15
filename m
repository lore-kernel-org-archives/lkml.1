Return-Path: <linux-kernel-owner+w=401wt.eu-S1763773AbZFOP52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763773AbZFOP52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763446AbZFOP5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:57:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43907 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763494AbZFOP47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:56:59 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
In-Reply-To: <alpine.DEB.1.10.0906151148300.11467@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
	 <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906151051240.19931@gentwo.org>
	 <1245077891.23207.48.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906151101580.23995@gentwo.org>
	 <1245078661.23207.50.camel@penberg-laptop>
	 <84144f020906150827k1b8c0ce4q5ed4d140f7ca869@mail.gmail.com>
	 <alpine.DEB.1.10.0906151148300.11467@gentwo.org>
Date: Mon, 15 Jun 2009 18:57:00 +0300
Message-Id: <1245081420.23207.58.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 11:51 -0400, Christoph Lameter wrote:
> On Mon, 15 Jun 2009, Pekka Enberg wrote:
> 
> > > OK, I can clean this up, no problem.
> >
> > Actually, there's a slight complication here. If I push gfp mask to
> > __might_sleep(), lockdep_trace_alloc() and so on, the mask is
> > effective _everywhere_ even outside of slab. Yes, it makes sense if we
> > push the masking right down to the page allocator but I wonder if
> > that's something we want to do at this point?
> 
> __might_sleep just should not trigger right? The mask does not need to be
> passed. __might_sleep may be called uselessly during bootup if __GFP_WAIT
> is set. But it should not trigger any output. Look at the initial
> statements of __might_sleep: They are already prepared to simply return in
> the early boot case.

Oh, yeah, you're right about __might_sleep() so we can just ignore that.

But we still have bit of a problem for should_failslab() and
__lockdep_trace_alloc(). We might be able to deal with the former by
adding system_state check but for the latter, we need to mask the gfp
flags. Hmm.

			Pekka

