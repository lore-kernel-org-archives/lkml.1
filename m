Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYGXKpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYGXKpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYGXKpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:45:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbYGXKpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:45:14 -0400
Date: Thu, 24 Jul 2008 12:44:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: BUILD_IRQ say .text to avoid .data.percpu
Message-ID: <20080724104459.GI28817@elte.hu>
References: <Pine.LNX.4.64.0807211828470.26173@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807211828470.26173@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> When I edit the x86_64 Makefile to -fno-unit-at-a-time, bootup panics
> on 0xCCs in IRQ0x3e_interrupt(): IRQ0x20_interrupt etc. have got linked
> into .data.percpu.  Perhaps there are other ways of triggering that:
> specify ".text" in the BUILD_IRQ() macro for safety.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

applied to tip/x86/urgent, thanks Hugh.

> I've been using -fno-unit-at-a-time (to lessen inlining, for easier 
> debugging) for a long time, but never saw this until Mike's percpu 
> mods came in: I mention this so you're on the lookout, just in case 
> other things are more likely to go into the wrong section now.  (I did 
> give Mike a private headsup on this a couple of weeks ago, in case it 
> helped with problems he was having with percpu, but in fact it didn't 
> help.)

Should we perhaps enable this automatically on CONFIG_FRAME_POINTER=y 
builds? Although a separate, default-off config option might be better, 
i'd not be surprised if there were more regressions in this area, it's a 
seldom used build vector.

	Ingo
