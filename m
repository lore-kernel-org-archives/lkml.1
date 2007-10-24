Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXJXMMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXJXMMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbXJXMMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:12:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56630 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467AbXJXMMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:12:35 -0400
Date: Wed, 24 Oct 2007 14:12:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux v2.6.24-rc1
Message-ID: <20071024121218.GA23548@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024080451.GA32690@infradead.org> <20071024110733.GA1374@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024110733.GA1374@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Oct 24, 2007 at 09:04:51AM +0100, Christoph Hellwig wrote:
> > On Tue, Oct 23, 2007 at 09:19:16PM -0700, Linus Torvalds wrote:
> > > In short, we just had an unusually large amount of not just x86 merges, 
> > 
> > Btw, can we please finis up this merge a little more before we freeze
> > 2.6.24?  The way we currently have leftovers of arch/i386/ and arch/x86_64/
> > is quite a nightmare and not how the other architectures were merged.
> 
> If these 10 files gives you nightmares then poor soul ;-)
> 
> Anyway - the primary issue is the two defconfig files and the Kconfig stuff.
> For defconfig we can inheritate the solution from powerpc where
> the defconfig file is selected based on architecture.
> Something like a
> DEFCONFIG := defconfig_$(ARCH)
> 
> and then stuff them in configs/ directory.
> 
> The Kconfig stuff could be handled by special casing in scripts/kconfig.
> We cannot just do the more obvious which is source the files since
> they have conflicting choice symbols.
> That could be fixed but requires a bit more work to do so - since we need
> to track all relevant usages of the choice symbols and rename these.
> We could also teach kconfig to allow duplicate symbols names in two choices
> but Roman Zippel has not done that yet.
> 
> The Makefile stuff is trivial to merge.

yes. But even Makefile merging can be surprisingly nontrivial at times: 
we had bugs in earlier versions of the unification due to link ordering 
and silent init section dependencies in the code. When we unified the 
makefiles certain init code broke because the initcall ordering changed. 
That's why we went for the "stupid, mechanic unification" approach first 
- to always have a 100% correct fallback position that people can bisect 
to.

	Ingo
