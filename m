Return-Path: <linux-kernel-owner+w=401wt.eu-S935077AbZJOJEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935077AbZJOJEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935047AbZJOJEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:04:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935046AbZJOJEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:04:10 -0400
Date: Thu, 15 Oct 2009 11:03:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: David Rientjes <rientjes@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Message-ID: <20091015090301.GC10546@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <20091014073306.GB22778@elte.hu> <alpine.DEB.1.00.0910140037140.29264@chino.kir.corp.google.com> <200910150143.18755.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910150143.18755.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> On Wednesday 14 October 2009, David Rientjes wrote:
> > On Wed, 14 Oct 2009, Ingo Molnar wrote:
> > Yeah, my patches build upon the base that you originally proposed.  I
> > like the `+' suffix for configs with CONFIG_LOCALVERSION_AUTO that
> > aren't vanilla kernels.
> 
> That is fine for custom kernels. I still maintain that it is hopelessly
> wrong for distro kernels.
> 
> Distro kernels generally have their own naming schemes.
> Debian uses: 2.6.30-2-amd64 (<version>-<ABI>-<flavor>)
> Fedora uses: 2.6.30.5-43.fc11.i586
> 
> And those kernel versions implicitly already contain the information 
> that they are not vanilla kernels. So a "+" suffix is totally 
> redundant.

It's not "totally redundant" _AT ALL_.

"2.6.30+-2-amd64" tells us that not only do we have the usual per distro 
patches on top of vanilla .30 (which patches can be found in the deb or 
src.rpm), but we _ALSO_ have extra _vanilla kernel_ commits since 
v2.6.30.

So it is very much meaningful. If i hunt a weird bug visible in a distro 
but not visible in my reproduction, i will be alerted to the fact that 
the distro isnt using a precise tag as a base but something inbetween.

That is useful information. Why do you keep insisting that it's "totally 
redundant"? It is clearly not. It's a property of the upstream kernel 
version - any per distro pile of patches on top of that is a different 
space. _Both_ pieces of information are important - that's why Debian 
put that -5 there.

Besides, distros building on kernels inbetween -rc's is very rare. If it 
happens it's sufficiently unusual to alert users to that fact via the 
'+' sign. The '+' sign will go away if a distro uses a precise upstream 
version.

	Ingo
