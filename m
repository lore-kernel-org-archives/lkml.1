Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbYHRHmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbYHRHmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYHRHmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:42:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYHRHmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:42:38 -0400
Date: Mon, 18 Aug 2008 09:42:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] lockdep: fix spurious 'inconsistent lock state' warning
Message-ID: <20080818074221.GD30694@elte.hu>
References: <1219019197-17744-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219019197-17744-1-git-send-email-dbaryshkov@gmail.com>
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


* Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Since f82b217e3513fe3af342c0f3ee1494e86250c21c lockdep can output 
> spurious warnings related to hwirqs due to hardirq_off shrinkage from 
> int to bit-sized flag. Guard it with double negation to fix the 
> warning.
> 
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

good spotting! Applied to tip/core/urgent, thanks Dmitry.

I'm wondering, is there any way to teach gcc some sanity here - a safer 
variant of bitfields, that is just not allowed to overflow into or 
corrupt nearby fields? The fact that a benign looking hlock->state = 15 
can corrupt other fields worries me quite a bit. Valid C semantics or 
not, this is a totally dangerous construct. The space savings are very 
real though, so it would be nice to get 'safer bitfields', somehow.

	Ingo
