Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZFSTkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZFSTkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZFSTko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:40:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbZFSTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:40:44 -0400
Date: Fri, 19 Jun 2009 12:39:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kyle@mcmartin.ca
Subject: Re: [GIT PULL] percpu for 2.6.31
In-Reply-To: <20090619053944.GB8162@elte.hu>
Message-ID: <alpine.LFD.2.01.0906191235490.16802@localhost.localdomain>
References: <4A39F5B4.1070305@kernel.org> <alpine.LFD.2.01.0906181421460.16802@localhost.localdomain> <4A3AC0BA.4000407@kernel.org> <4A3AEE42.4010300@kernel.org> <20090619053944.GB8162@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Jun 2009, Ingo Molnar wrote:
> 
> ( Many wont btw: we still dont have lockdep support in all
>   architectures - 3 years and counting. It's a highly useful purely
>   sw feature with zero hardware dependencies. Fortunately it's
>   well-modularized and the functionality is non-essential. Percpu
>   allocation is not so lucky as it's essential functionality. )

When it coems to code coverage, x86 matters _so_ much more than any other 
architecture, that verification features like lockdep etc are way more 
important on x86 than on anything else.

Sure, there may be locking issues in some arch-specific code, and other 
architectures could be better off caring. But the advantage of lockdep for 
some pissant architecture that has a very limited user base (maybe lots of 
chips, but much more limited _use_ - fewer drivers, fewer workloads etc) 
is much lower, since those architectures know that x86 will give them 99% 
of the coverage.

So it's quite reasonable to think that other architectures simply care 
less.

			Linus
