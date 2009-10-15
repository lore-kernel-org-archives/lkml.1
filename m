Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZJOOOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZJOOOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZJOOOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:14:11 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:54613 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbZJOOOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:14:10 -0400
From: Frans Pop <elendil@planet.nl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Date: Thu, 15 Oct 2009 16:13:07 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910150143.18755.elendil@planet.nl> <alpine.DEB.1.00.0910150029450.10850@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0910150029450.10850@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910151613.10334.elendil@planet.nl>
X-OriginalArrivalTime: 15 Oct 2009 14:13:33.0385 (UTC) FILETIME=[ADC3E390:01CA4DA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009, David Rientjes wrote:
> And that's why I suggested, in addition to my patch, that we allow "make
> LOCALVERSION=" to override the `+' suffix for kernels compiled without
> CONFIG_LOCALVERSION_AUTO.  In your examples, they would pass
> LOCALVERSION=-2-amd64 or LOCALVERSION=-43.fc11.i586, respectively, to
> make.

Who says they are using LOCALVERSION to add the suffix?

> > My main argument is that if they build kernels from an SCM, which is
> > quite likely, they should not suddenly get a "+" appended to those
> > versions. And IMO they should also not have to patch the Makefile to
> > avoid it. If this change is made, it should be made in such a way that
> > old version naming schemes are still possible.
>
> They are, with my suggestion to allow make LOCALVERSION= to override the
> `+'.  The question I posed directly to you was this: how does adding a
> unique string passed by the user for a more descriptive kernel version
> interact poorly with certain packaging requirements?  You've given two
> examples that are _perfect_ use cases for my suggestion.

I'm not a Debian kernel maintainer, so I cannot answer that question. I 
will alert the Debian kernel team to this discussion so they can respond 
for themselves.

The thing is that you are assuming people do things in a certain way and 
your patches will break existing naming schemes for anybody who happens to 
do things slightly differently. My proposal offered full backwards 
compatibility for people who know what they are doing.

> > Using LOCALVERSION= for that would be wrong as it is on a different
> > level from AUTOVERSION. They should be independent. However, that
> > basic approach of using an environment variable is certainly an
> > option.
>
> Now I'm confused, because currently LOCALVERSION= can only be used when
> CONFIG_LOCALVERSION_AUTO is defined; in other words, it's completely
> dependent on it.  My patch changes that and seems to be your desire as
> well?

That change seemed logical to me. And I did say my patch was on top of 
yours, so yes, my comment was based on that change being implemented.

> > So I propose the following patch on top of the patch proposed by
> > David. It offers a clean out for users who explicitly do not want
> > *any* SCM-based suffix added to their kernel version, and is IMO both
> > 1) obvious enough for expert users and 2) obscure enough that regular
> > users are unlikely to abuse it. Is that acceptable?
>
> No, it actually makes things much worse because now instead of forcing
> the user to post his .config to determine the setting of
> CONFIG_LOCALVERSION_AUTO to intepret the version string, it forces them
> to recall what their KBUILD_NO_LOCALVERSION_EXTRA environment variable
> happened to be at the time of build.

As I've already said, I think that build variable is sufficiently obscure 
that I expect it will only be used by people who know what they are doing.

And I can only repeat that even with your patch you will never get 100% 
coverage. People who really don't want the "+" will simply patch it out. 
Why not give them a clean way to avoid it?
