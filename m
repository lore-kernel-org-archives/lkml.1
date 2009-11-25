Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbZKYQ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbZKYQ0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbZKYQ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:26:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52382 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190AbZKYQ0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:26:19 -0500
Date: Wed, 25 Nov 2009 17:25:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jakub Jelinek <jakub@redhat.com>, Andrew Haley <aph@redhat.com>,
       "H.J. Lu" <hjl.tools@gmail.com>, rostedt@goodmis.org,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
 messing with mcount prologue
Message-ID: <20091125162556.GA14233@elte.hu>
References: <4B06EF6F.2050507@redhat.com>
 <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com>
 <4B0972C9.302@redhat.com>
 <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com>
 <4B0BF119.4070704@redhat.com>
 <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain>
 <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com>
 <alpine.LFD.2.00.0911251604280.24119@localhost.localdomain>
 <20091125154452.GA9456@elte.hu>
 <alpine.LFD.2.00.0911251650570.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911251650570.24119@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 25 Nov 2009, Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Tue, 24 Nov 2009, Jakub Jelinek wrote:
> > > 
> > > > On Tue, Nov 24, 2009 at 03:55:49PM +0100, Thomas Gleixner wrote:
> > > > > > you should compile your code with -maccumulate-outgoing-args, and there's
> > > > > > no need to use -mtune=generic.  Is that right?
> > > > > 
> > > > > Seems to work. What other side effects has that ?
> > > > 
> > > > Faster code, significant increase in code size though.  Note that on many
> > > > architectures it is the only supported model.
> > > 
> > > Just checked on the affected -marchs. The increase in code size is 
> > > about 3% which is not that bad and definitely acceptable for the 
> > > tracing case. Will zap the -mtune=generic patch and use 
> > > -maccumulate-outgoing-args instead.
> > 
> > hm, 3% sounds quite large :( dyn-ftrace is enabled in distro configs, so 
> > 3% is a big deal IMO.
> 
> Distro-configs have -mtune=generic anyway. So it's not changing
> anything for them.
> 
> I'm talking about the -march flags which result in that weird code
> (pentium-mmx ....).

ok!

	Ingo
