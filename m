Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbYG3S0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbYG3S0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYG3S0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:26:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35775 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYG3S0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:26:33 -0400
Date: Wed, 30 Jul 2008 20:25:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080730182539.GA17140@elte.hu>
References: <20080729172917.185593000@linux-os.sc.intel.com> <488FA318.3040905@zytor.com> <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730100326.GA9683@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Well, in this case the conflicts seem to be quite heavy, so i'd 
> suggest to use the method we have used for x86/x2apic and for 
> xen-64bit:
> 
> Merge the affected topics into tip/x86/core. Then merge x86/core into 
> x86/xsave, and put the xsave patches ontop of that base.
> 
> This way x86/xsave is a 'derived' topic and optional until it's 
> proven, but one that is still mergable once all the dependent topics 
> go upstream. We'd only have to rebase it in the (unlikely) event of 
> there being some major problem with any of the topics merged into 
> x86/core.

I've restructured tip/x86/xsave to be like this, and it can now be 
merged into tip/master without conficts.

I briefly merged it into tip/master to test it, but after about 10 
randconfig iterations it ran into a spontaneous reboot crash. There's 
nothing in the log, the box (an Athlon64 X2) just reboots spontaneously. 
Removing the x86/xsave changes makes the system boot up fine.

I've pushed out the tree i tested into the tip/tmp.x86/xsave.broken 
branch. The bad config is:

  http://redhat.com/~mingo/misc/config-Wed_Jul_30_20_09_12_CEST_2008.bad

Two crashlogs are here:

  http://redhat.com/~mingo/misc/crash-Wed_Jul_30_20_09_12_CEST_2008.log

the serial log just stops at a certain point. It's not at a specific 
point, but the crash happened both times i tried to boot it.

	Ingo
