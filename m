Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZD1RzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZD1RzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZD1Ryz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:54:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbZD1Ryy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:54:54 -0400
Date: Tue, 28 Apr 2009 10:50:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: david@lang.hm
cc: Tejun Heo <tj@kernel.org>, Dave Airlie <airlied@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
In-Reply-To: <alpine.DEB.1.10.0904281019580.17268@asgard.lang.hm>
Message-ID: <alpine.LFD.2.00.0904281043420.22156@localhost.localdomain>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>  <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
 <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain> <alpine.DEB.1.10.0904281019580.17268@asgard.lang.hm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Apr 2009, david@lang.hm wrote:
> 
> the other items that you mention (netfilter, etc) are actually the easier ones
> to deal with (you know what you want), and also the place where it's
> impossible to detect what's wanted.

Very wrong.

Especially about the "you know what you want". 

Quite frankly, those choices can be hard even for kernel developers, never 
mind normal users. Have you looked at the _hundreds_ of options for 
various iptables filtering? Do you know which ones you need?

[ Ok, so now you can say "give me the non-complex set" and it will pick 
  the normal ones. It will still ask you about others. I had to ask for 
  that option, and when I did, even the main netfilter developers had to 
  say "ok, I'll have to check".

  The point being - normal mortals have almost no way of knowing which sw 
  features are good, and which are bad. And yes, some of them are really 
  bad. They not only increase compile time, some of them make for horrible 
  performance. You may want to enable some options that increase debug 
  coverage, but can you tell which of them impact kernel performance by a 
  factor of ten on some loads? ]

And that's where starting with a "suggested config" can help. And some of 
the suggestions really are distro-specific, because sometimes different 
distributions depend on different features.

> > So having some kind of (probably inevitably fairly complex) script that
> > you could run to get a config would be good. The problem is that the
> > script would need to be distributed with the kernel, yet it would often
> > also have some nasty distro issues.
> 
> I've seen people talk about creating such tools, but the responses that I've
> seen have tended to discourage them.

I suspect that they'd generally end up handling the easy cases, and seldom 
anything more. At which point they're not all that useful.

		Linus
