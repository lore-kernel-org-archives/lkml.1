Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbYHAUzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbYHAUzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYHAUzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:55:33 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:55249 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbYHAUzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:55:32 -0400
Date: Fri, 1 Aug 2008 22:55:15 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Ray Lee <ray-lk@madrabbit.org>
cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Avoid needless strlen() for attributes
In-Reply-To: <2c0942db0808011336h32112df2v706a452a6db518ba@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0808012245230.2294@titan.stealer.net>
References: <alpine.LNX.1.10.0808012226560.2294@titan.stealer.net> <2c0942db0808011336h32112df2v706a452a6db518ba@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Fri, 01 Aug 2008 20:55:30 +0000
	Bayes: 0.0096 Tokens: new, 181; hammy, 4; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0096]
X-Spam-Signature: fbcecd8cadbf09f271534514990aeb15c0172d8e
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008, Ray Lee wrote:

> On Fri, Aug 1, 2008 at 1:30 PM, Sven Wegener <sven.wegener@stealer.net> wrote:
> > There's no need for the additional call to strlen(), we can directly return the
> > value returned by sprintf(). We now return a length value that doesn't include
> > the final '\0', but user space shouldn't bother about it anyway.
> 
> Why not just add 1 to the return value of sprintf, and guarantee that
> userspace sees the same thing before and after? It's simple enough to
> do, and avoids guessing about what userspace may or may not be doing.

I thought about it, but all other places I looked at just do the return 
sprintf(...); thing, so we are consistent with what the other drivers do. 
And user space should be really ignoring the final '\0' currently. I know 
that this can be considered some user space API change, but I think it is 
in the range of what the API allows us. If noone has strong objections 
against leaving the -1 out, I would keep it that way. But it's OK for me, 
if someone really wants it there, but I don't think it's necessary.

Sven
