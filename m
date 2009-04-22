Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZDVJOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZDVJOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZDVJOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:14:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54643 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbZDVJOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:14:16 -0400
Date: Wed, 22 Apr 2009 11:12:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
Message-ID: <20090422091226.GA18226@elte.hu>
References: <20090415140959.GD12760@elte.hu> <20090415120307.GB17775@elte.hu> <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com> <14172.1239795632@redhat.com> <1488.1239801659@redhat.com> <9843.1239808150@redhat.com> <30674.1240338986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30674.1240338986@redhat.com>
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


* David Howells <dhowells@redhat.com> wrote:

> Any idea what this:
> 
> 	#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)
> 
> is intended for?

it is a mixed type of percpu variable: which is per CPU but which 
can (and will) also be accessed from other CPUs. This way we 
basically cache-line align it and make sure nearby percpu variables 
dont get caught up in any cacheline bounces. It was introduced a 
couple of years ago.

	Ingo
