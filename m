Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYFYPWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYFYPWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYFYPWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:22:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60968 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbYFYPWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:22:46 -0400
Date: Wed, 25 Jun 2008 17:22:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen
	support
Message-ID: <20080625152212.GA3442@elte.hu>
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080625084253.GA11524@elte.hu>
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

> Anyway, that's all theory - i'll try out your patchset in -tip to see 
> what breaks in practice ;-)

i've put the commits (and a good number of dependent commits) into the 
new tip/x86/xen-64bit topic branch.

It quickly broke the build in testing:

 include/asm/pgalloc.h: In function ‘paravirt_pgd_free':
 include/asm/pgalloc.h:14: error: parameter name omitted
 arch/x86/kernel/entry_64.S: In file included from 
 arch/x86/kernel/traps_64.c:51:include/asm/pgalloc.h: In function ‘paravirt_pgd_free':
 include/asm/pgalloc.h:14: error: parameter name omitted
 [...]

with this config:

  http://redhat.com/~mingo/misc/config-Wed_Jun_25_16_37_51_CEST_2008.bad

this could easily be some integration mistake on my part, so please 
double-check the end result.

Merging it into tip/master is a bit tricky, due to various interactions. 
This should work fine if you check out the latest tip/master:

  git-merge tip/x86/xen-64bit
  [ ... fix up the trivial merge conflict ... ]

i've already merged tip/x86/xen-64bit-base topic into master, to make it 
easier. (there were a few preconditions for the 64-bit Xen patches which 
arent carried in linux-next - such as the nmi-safe changes.)

	Ingo
