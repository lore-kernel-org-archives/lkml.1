Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYHTLAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYHTLAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYHTK75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:59:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59678 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbYHTK74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:59:56 -0400
Date: Wed, 20 Aug 2008 12:59:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Message-ID: <20080820105922.GC18524@elte.hu>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <200808181109.43203.rusty@rustcorp.com.au> <20080818075459.GH30694@elte.hu> <48A9472F.908@panasas.com> <20080819133422.GA24369@elte.hu> <48AAF5F7.6040709@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AAF5F7.6040709@panasas.com>
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


* Boaz Harrosh <bharrosh@panasas.com> wrote:

> If the user of virtio_has_feature() must pass a compile-time constant 
> then it must be converted to a MACRO, and then the BUILD_BUG_ON will 
> work. Or it should be changed to a BUG_ON() if fbit is a runtime 
> variable.

well, that's the question i'm asking: that sort of proposed 
BUILD_BUG_ON() variantcannot be used in inline functions like 
virtio_has_feature() does. If we get forced back to macros that's not an 
improvement.

Maybe the link-time last-line-of-defense mechanism i posed is the most 
flexible one perhaps after all? (it's ugly too but none of this is 
particularly pretty)

hm?

	Ingo
