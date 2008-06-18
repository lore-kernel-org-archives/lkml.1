Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbYFRMn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbYFRMn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYFRMnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:43:17 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:27140 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754843AbYFRMnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:43:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KC0q4S4eNPLwY56D3/UDAx19GNPO7rZbz8heERBVymCQUXtDLztNDwSiu74kiAHCYihWECZQfkr2qlPIexQzhM19jd5mwQJm7ZVG2T5I544f+3n0m33w7OavGEhWYUGKOEBYH2rgwbo0dybZQ3wsmwdKOWUYFrlp1PuDdQKOnUk=  ;
X-YMail-OSG: Lx4ytoQVM1kd7gcvpWEuOJoPMDllGs8dhU8ni6mEj59oJwwU1Z.Ba.BkgpVi1i01RjbR3HcK5zmBcVn4BkitD36NLOaJXASR4AbiKTX0uulSgx9.LKkb4imi6hHWeBeQxyw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
Date: Wed, 18 Jun 2008 22:42:48 +1000
User-Agent: KMail/1.9.5
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <andi-suse@firstfloor.org>,
       "Clark Williams" <clark.williams@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Marin Mitov" <mitov@issp.bas.bg>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, akpm@osdl.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <200805252108.25011.mitov@issp.bas.bg> <1213791416.16944.222.camel@twins> <4858C68C.BA47.005A.0@novell.com>
In-Reply-To: <4858C68C.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806182242.49245.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 22:25, Gregory Haskins wrote:
> >>> On Wed, Jun 18, 2008 at  8:16 AM, in message

> > Yeah - migrate_disable() has been proposed several times. The reason I
> > don't like it is that is creates scheduling artefacts like latencies by
> > not being able to load-balance (and thereby complicates all that, and
> > you know we don't need more complication there).
>
> True, and good point.  But this concept would certainly be useful to avoid
> the heavyweight (w.r.t. latency) preempt-disable() in quite a few different
> areas, so if we can make it work with reasonable visibility, it might be
> nice to have.

It just seems like pretty worthless bloat to me.

There are _some_ cases where it can be used, but nobody has been
able to come up with compelling uses really. I don't think this
case is helped very much either because the logic in there using
preempt-disable is fine, isn't it?

Except that it should also have a cond_resched in it. Seems like
an ideal place to put cond_resched because it is not a fastpath.
