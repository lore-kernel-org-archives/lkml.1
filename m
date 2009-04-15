Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZDOQ4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZDOQ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZDOQ4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:56:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58375 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZDOQ4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:56:09 -0400
Date: Wed, 15 Apr 2009 18:54:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
Message-ID: <20090415165446.GB10345@elte.hu>
References: <20090415140959.GD12760@elte.hu> <20090415120307.GB17775@elte.hu> <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com> <14172.1239795632@redhat.com> <1488.1239801659@redhat.com> <9843.1239808150@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9843.1239808150@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* David Howells <dhowells@redhat.com> wrote:

> I'd like Linus to pull my first patch, if he will.  That'll at 
> least allow FRV to build.  Could you review it?  That's the email 
> that started this thread, ensubjected:
> 
> 	[PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()

hm, this moves the section defines from a generic header into 
platform headers in essence - not a good move IMO.

Why not start a new linux/percpu_types.h header with just those 
defines in place, include it both from linux/percpu.h and from all 
the asm*/percpu.h files you modify in that patch?

This would fix your build problem minimally - and it would also seed 
the new percpu_types.h file that could start the untangling of this 
dependency hell.

(it would also be much easier to verify for correctness - you just 
move bits and include it trivially in places that need it.)

Am i missing something?

	Ingo
