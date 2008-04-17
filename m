Return-Path: <linux-kernel-owner+w=401wt.eu-S1763672AbYDQKcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763672AbYDQKcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbYDQKcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:32:31 -0400
Received: from saeurebad.de ([85.214.36.134]:59719 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756908AbYDQKca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:32:30 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417011401.ea3e70f0.akpm@linux-foundation.org>
Date: Thu, 17 Apr 2008 12:32:03 +0200
In-Reply-To: <20080417011401.ea3e70f0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 17 Apr 2008 01:14:01 -0700")
Message-ID: <87skxkepr0.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton <akpm@linux-foundation.org> writes:

> - extensive damage to the page-flags patches
>
>   Did you check that all architectures and configurations still have
>   sufficient page flags for us to be able to consume another one for
>   kmemcheck?  The MM developers have put much, much effort into avoiding
>   running out of flags over numerous years and afaik none of them even know
>   that this debug feature is using one of the few remaining ones.
>
>   What do we do when we run out?

Would it be feasible to add another unsigned long to struct page?  I
mean, extending such a common structure always sucks, but for
emergency...

#define PageFoobar(page)	test_bit(PG_foobar, &(page)->flags2)

Of course the essential core flags should always be in ->flags but
perhaps we could have a symbol CONFIG_NEED_EXTRA_PAGE_FLAGS that gets
selected by kmemcheck (and other candidates that are unlikely to be
enabled most of the time) and then #ifndef ->flags2 out.

	Hannes
