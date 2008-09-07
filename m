Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYIGHhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYIGHhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 03:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYIGHhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 03:37:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36048 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbYIGHhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 03:37:05 -0400
Date: Sun, 7 Sep 2008 09:36:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/13] smp: reduce stack requirements for genapic
	send_IPI_mask functions
Message-ID: <20080907073620.GC14907@elte.hu>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906235036.891970000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> [Note: all these changes require some more testing but I wanted to 
> solicit comments before then, hence the "RFC" in the subject line. 
> -thanks! Mike]

these changes are certainly looking very nice.

They do interact with a ton of high-flux topics in -tip, so i'd prefer 
to start integrating/testing this straight away (today-ish), before the 
target moves yet again. Are there any showstoppers that speak against 
that?

The plan would be to not keep this in a single topic but to spread them 
into their closest topic (tip/x86/x2apic, tip/irq/sparseirq etc.) - are 
there any cross-topic dependencies to be careful about? Most of the 
commits seem to be standalone. The debug patch would go into 
tip/cpus4096.

And more generally: how far away are we from being able to introduce 
struct cpumask and hide its implementation from most .c files? That 
would be rather efficient in preventing it from being put on the stack 
spuriously in one of the 30+ thousand Linux kernel source code files. 
Just like we hide the true structure of things like 'struct kmem_cache' 
and force them to always be used as pointers.

	Ingo
