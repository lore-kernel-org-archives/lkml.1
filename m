Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbXLTJuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbXLTJuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXLTJuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:50:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbXLTJuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:50:12 -0500
Date: Thu, 20 Dec 2007 10:49:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/5] x86: another attempt at x86 pagetable unification
Message-ID: <20071220094940.GA14227@elte.hu>
References: <20071219223534.129042140@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219223534.129042140@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Here's another round of the pagetable unification patches.  I've done 
> a few dozen rounds of randconfig builds on both 32- and 64-bit, so I 
> hope that will prevent compile problems in your test environment.
> 
> I've also boot-tested 64-bit and 32-bit PAE/non-PAE configs (both 
> paravirt and non-paravirt).

i've done a dozen random tests too and it's looking good so far. Nice 
work!

pgtable_32.h and pgtable_64.h still look a tiny bit messy from the 
include file dependencies POV. For example pgtable_32.h:

 #include <asm/processor.h>
 #include <asm/fixmap.h>
 #include <linux/threads.h>
 #include <asm/paravirt.h>

 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>

that asm/paravirt.h include is already present in pgtable.h, in a 
somewhat quirky way:

#ifdef CONFIG_PARAVIRT
#include <asm/paravirt.h>
#else  /* !CONFIG_PARAVIRT */

also, most of the:

  scripts/checkpatch.pl --file include/asm-x86/pgtable*.h

complaints are real ones and should be fixed.

would you be interested in cleaning up that stuff once and forever? It 
would be a fine approach if you just tried to quickly push for a "high 
quality" end result in a series of patches and sent that series to me, 
without having tested it fully through - i can figure out whatever build 
breakages and dependencies there still are. So there would be no 
expectation of getting such a cleanup series right in the first (or 
second, or third) attempt, this is spaghetti code that has been 
accumulated up for years. The important thing would be to be careful to 
not introduce runtime breakages accidentally - build breakages due to 
some include file dependency we can sort out just fine. Hm?

	Ingo
