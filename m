Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYJOWGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYJOWGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYJOWGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:06:06 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:37505 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbYJOWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:06:05 -0400
Date: Thu, 16 Oct 2008 00:05:46 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: David Miller <davem@davemloft.net>
cc: adobriyan@gmail.com, davej@redhat.com, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sparc64 allmodconfig build failure...
In-Reply-To: <20081014.154916.232117559.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.0810152354350.28346@titan.stealer.net>
References: <alpine.LNX.2.00.0810140945060.13897@titan.stealer.net> <20081014120605.GB23213@x200.localdomain> <alpine.LNX.2.00.0810141434030.13897@titan.stealer.net> <20081014.154916.232117559.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 15 Oct 2008 22:06:02 +0000
	Bayes: 0.4637 Tokens: new, 189; hammy, 4; neutral, 1; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4637]
X-Spam-Signature: 616d6fae5a6f04dbe27426162e2ac5fa7b22bdb6
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, David Miller wrote:

> From: Sven Wegener <sven.wegener@stealer.net>
> Date: Tue, 14 Oct 2008 23:08:17 +0200 (CEST)
> 
> > Yeah, with the default governor being any of supported governors, we
> > either need some ugly #ifdef mess to only export the governor that
> > is selected or just revert to the old code, which unconditionally
> > exports all governors. Or something like the patch below. With the
> > additional modules that I oversaw and that require the export, I'm
> > fine with just reverting the commit, although I think that
> > encapsulating the default governor decision in a built-in function
> > is cleaner than having modules reference different symbols depending
> > on configuration.
> 
> Personally I prefer the revert.

Fine with me. Dave J. or Linus, please revert 
c4d14bc0bb5d13e316890651ae4518b764c3344c, because it breaks allmodconfig 
as reported by David Miller on architectures that have cpufreq code that 
can be build as a module. All ways to only export the default governor are 
a ifdef mess and ugly, let's just revert the commit.

Thanks,
Sven
