Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbYHMItW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbYHMItW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756995AbYHMIsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:48:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972AbYHMIsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:48:45 -0400
Date: Wed, 13 Aug 2008 10:48:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Propagate new nonpanic bootmem macros to
	CONFIG_HAVE_ARCH_BOOTMEM_NODE
Message-ID: <20080813084819.GA23417@elte.hu>
References: <489721D1.76E4.0078.0@novell.com> <87skt99vmz.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87skt99vmz.fsf@skyscraper.fehenstaub.lan>
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


* Johannes Weiner <hannes@saeurebad.de> wrote:

> Commit 74768ed833344b "page allocator: use no-panic variant of 
> alloc_bootmem() in alloc_large_system_hash()" introduced two new 
> _nopanic macros which are undefined for CONFIG_HAVE_ARCH_BOOTMEM_NODE.

the above bootmem commit from yesterday broke the -rc3 32-bit NUMA 
build:

 mm/page_alloc.c: In function ‘alloc_large_system_hash':
 mm/page_alloc.c:4440: error: implicit declaration of function ‘alloc_bootmem_nopanic'
 mm/page_alloc.c:4440: warning: assignment makes pointer from integer without a cast

i have queued your fix up in tip/x86/urgent, thanks Johannes.

	Ingo
