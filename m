Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbZBERaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbZBERaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZBER3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:29:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZBER3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:29:49 -0500
Date: Thu, 5 Feb 2009 18:29:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tim Pepper <tpepper@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Genapic cleanup & NUMAQ/es7000 removal
Message-ID: <20090205172941.GA24599@elte.hu>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org> <eada2a070902050815h6ba682e2u158c4bb7c32f89ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eada2a070902050815h6ba682e2u158c4bb7c32f89ef@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Pepper <tpepper@gmail.com> wrote:

> On Fri, Jan 30, 2009 at 2:17 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > Just to demonstrate the clean up possibilities by removing es7000
> > and numaq here's a sample patch series. It doesn't actually remove
> > the es7000/numaq code, but just marks them broken and then
> > removes all the hooks only used by them. I'm not actually sure
> > I caught all the now unused hooks, there are probably now more.
> > Also I think there's still some other NUMAQ only code in smpboot.c
> > that could be exercised.
> >
> > This removes 6 hooks and 2 fields out of struct genapic (out of 26
> > hooks, a reduction of ~23%!)
> >
> > The first three patches are independent cleanups that should
> > be applied anyways.
> >
> > This gives a nice generic cleanup:
> 
> These look good to me for inclusion along with the big "x86: unify genapic 
> code, unify subarchitectures, remove old subarchitecture code" series, or 
> as Andi's indicated the initial cleanups themselves if the other big set 
> doesn't make the 2.6.30 for some reason.  For this series:
> 
> Acked-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>

I'm not going to apply that series for the reasons i outlined in the NUMAQ 
discussion already. The runtime callbacks arent really a maintenance 
problem: most of them are in boot code so it's not a runtime overhead issue.

The build and code readability complications that came from the broken 
subarch design were the real maintenance problem - and i fixed that. If i 
wanted to simply drop these subarchitectures i could have done that via 5 
straightforward patches.

The unified x86 tree and the whole x86 platform is all about being 
compatible. We do drop hardware features occasionally but only when they are 
undeniably not reachable via any Linux user anymore and have been broken and 
unfixed for a long time. We are not there yet.

We could de-quirk the whole x86 code but then there would not be much code 
left :-)

	Ingo
