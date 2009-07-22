Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbZGVRRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbZGVRRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZGVRR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:17:29 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:43564 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZGVRR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:17:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x54JBGyTk+EXwc9oTxIxMZUu0KD9AFQWd/2qTYe41k+2fTD/CRiiz+KyvDn64Tx0Gh
         j/tkBAgKR5DvBkl4SzAPSqRK8fxiKUQ9DB1im4thxbTgwbuBSvL9hAp6L6/37cJBfqMV
         AQZ0RhzshovQ93yUMQxsFwOzF3i1YD6IUhYPQ=
MIME-Version: 1.0
In-Reply-To: <1248089955.15751.8494.camel@twins>
References: <1247725694-6082-6-git-send-email-fweisbec@gmail.com>
	 <tip-613afbf83298efaead05ebcac23d2285609d7160@git.kernel.org>
	 <4A6413AB.2050807@cn.fujitsu.com> <20090720081210.GA5309@nowhere>
	 <1248089955.15751.8494.camel@twins>
Date: Wed, 22 Jul 2009 19:17:25 +0200
Message-ID: <c62985530907221017i427b1ae1s8cbb593106c658a1@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Pull up the might_sleep() check into 
	cond_resched()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/20 Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> On Mon, 2009-07-20 at 04:12 -0400, Frederic Weisbecker wrote:
>
> > Hm, I can read that in fs/dcache.c:512
> >
> > /* dentry->d_lock was dropped in prune_one_dentry() */
> > cond_resched_lock(&dcache_lock);
>
> dentry->d_lock != dcache_lock
>
> > Isn't it a mususe of cond_resched_lock() ?
> > In this case, dcache.c should be fixed.
>
> Both sites look good wrt locking. So there's something else fishy.
>

(Resend in text/plain, sorry.)


Ah, I think I've got it. In case of !CONFIG_PREEMPT, the spinlocks of
course don't play
with preemption, making no change reflected in the preempt_count().
The assumption of preempt_count() = 1
is then false.

I prepare a patch.
Thanks.
