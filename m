Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZERHaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZERHaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZERHaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:30:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45848 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZERHaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:30:12 -0400
Date: Mon, 18 May 2009 09:29:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: tip: patches in git for irq and numa
Message-ID: <20090518072952.GA12460@elte.hu>
References: <4A05269D.8000701@kernel.org> <20090511095022.GA23121@elte.hu> <20090511163158.c4e4d334.akpm@linux-foundation.org> <20090512090704.GC18004@elte.hu> <4A0A6700.3070100@kernel.org> <20090513133635.GB7384@elte.hu> <4A0AFA6E.5050200@kernel.org> <20090515173521.GA29647@elte.hu> <4A0DE0ED.6090402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0DE0ED.6090402@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> irq related:
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git irq
> need to on top of tip/irq/numa

ok, these were nicely structured. the pci_routeirq patch had a build 
bug for !CONFIG_PCI.

( I added an #ifdef for now, it might make sense to send a clean-up 
  patch in the next merge window (not now) to factor out a 
  pci_routeirq_enable() method that does all this cleanly. )

Also, please add appropriate Cc: lines to the commit logs in the 
future, beyond the LKML-Reference tgs.

> for memoryless node support: 
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git numa
> and it is on top of tip/master

small note: you could have based these on x86/mm btw. - that's where 
these patches go, typically.

regarding subject lines:

 d03a6a4: mm: clear N_HIGH_MEMORY map before se set it again -v2
 02ce039: x86: fix system without memory on node0 -v2
 8c1aec8: x86: fix node_possible_map logic -v2
 44a633c: x86: remove MEMORY_HOTPLUG_RESERVE related code -v2

please never put '-v2' type of tags into the title of commits. In 
the title of patches they can be put here:

  [PATCH, v2] x86: fix system without memory on node0

that saves maintainers a bit of typing work.

Also, you included:

 d03a6a4: mm: clear N_HIGH_MEMORY map before se set it again -v2

with no Acks from MM folks yet. So i skipped that one and will 
follow up about it.

	Ingo
