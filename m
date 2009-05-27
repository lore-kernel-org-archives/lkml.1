Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbZE0WfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbZE0WfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZE0We5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:34:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35942 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbZE0We5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:34:57 -0400
Date: Thu, 28 May 2009 00:34:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rik van Riel <riel@redhat.com>
Cc: "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090527223421.GA9503@elte.hu>
References: <20090520183045.GB10547@oblivion.subreption.com> <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A187BDE.5070601@redhat.com>
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


* Rik van Riel <riel@redhat.com> wrote:

> Ingo Molnar wrote:
>
>> What you are missing is that your patch makes _no technical 
>> sense_ if you allow the same information to leak over the kernel 
>> stack. Kernel stacks can be freed and reused, swapped out and 
>> thus 'exposed'.
>
> Kernel stacks may be freed and reused, but Larry's latest patch 
> takes care of that by clearing them at page free time.
>
> As for being swapped out - I do not believe that kernel stacks can 
> ever be swapped out in Linux.

yes, i referred to that as an undesirable option - because it slows 
down pthread_create() quite substantially.

This needs before/after pthread_create() benchmark results.

	Ingo
