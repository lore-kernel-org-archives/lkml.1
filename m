Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYGIKOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYGIKOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYGIKOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:14:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60174 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbYGIKOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:14:09 -0400
Date: Wed, 9 Jul 2008 12:13:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 0/17] Series to introduce WARN()... a WARN_ON() variant
	that takes printk arguments
Message-ID: <20080709101348.GA30005@elte.hu>
References: <20080708093800.274504ba@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708093800.274504ba@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> Hi,
> 
> This patch series introduces WARN(), which is a WARN_ON() variant that 
> takes printk() like arguments. This was done after both akpm and I hit 
> several cases where this would have been useful; in addition, with 
> WARN(), we put the printk string inside the -----[ cut here ]----- 
> section, making it more likely that users (and tools like kerneloops) 
> pick up the message in addition to just the bare WARNING.
> 
> The first few patches have been in -mm for a long time; the later ones 
> are newer and introduce more users of WARN().

i've created a new -git based topic branch in tip/core/warn-API and 
picked up your patches:

 Arjan van de Ven (16):
      full tree: clear the WARN() namespace
      core: add a WARN() macro that acts like WARN_ON()+printk
      kobject: introduce WARN() usage in the kobject code
      irq: use WARN() in kernel/irq/manage.c
      mm: use WARN() in mm/vmalloc.c
      lockdep: use WARN() in kernel/lockdep.c
      irq: use WARN() in kernel/irq/chip.c
      x86: use WARN() in arch/x86/mm/ioremap.c
      x86: use WARN() in arch/x86/mm/pageattr.c
      x86: use WARN() in arch/x86/kernel
      block: use WARN() in block/
      driver core: use WARN() in drivers/base/
      core libs: use WARN() in lib/
      fs: use WARN() in fs/
      sysfs: use WARN() in fs/sysfs
      procfs: use WARN() in fs/proc/

it can be picked up via:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/warn-API

( Note, i added a few more tree-wide namespace preparation fixes to the 
  first patch - a few more came in since you first prepared this patch i 
  guess. )

	Ingo
