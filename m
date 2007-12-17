Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbXLQObz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbXLQObz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXLQObs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:31:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52578 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbXLQObr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:31:47 -0500
Date: Mon, 17 Dec 2007 15:30:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: Final kprobes rollup patches
Message-ID: <20071217143050.GA13290@elte.hu>
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu> <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu> <4766841B.1040500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766841B.1040500@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Masami,

* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Harvey and Ingo,
> 
> I'm working on another version of patches for unification.
> Currently cleaning up the patches.
> http://sources.redhat.com/ml/systemtap/2007-q4/msg00457.html
> I'll cleanup and repost it today.

cool! Please Cc: lkml and Harvey as well so that there's less overlap in 
unification work - Harvey spent quite some time unifying and cleaning up 
the kprobes code during the past week.

So i think we could/should use Harvey's latest series as a base, those 
are pretty finegrained already. Note that they break 64-bit kprobes 
though, with such a config:

 CONFIG_KPROBES=y
 CONFIG_NET_TCPPROBE=y

so it crashes with an int3 in the TCP code. It's probably some trivial 
typo somewhere, as 32-bit works fine.

the coordinates for x86.git#mm can be found below - that tree already 
includes Harvey's latest kprobes series. I'll try to bisect the 64-bit 
breakage now.

	Ingo

------------------>
 git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
 cd linux-2.6.git
 git-branch x86
 git-checkout x86
 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

(do subsequent pulls via "git-pull --force", as we frequently rebase the
git tree. NOTE: this might override your own local changes, so do this
only if you dont mind about losing thse changes in that tree.)

