Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZJNR7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZJNR7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZJNR7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:59:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48149 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbZJNR7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:59:33 -0400
Date: Wed, 14 Oct 2009 19:58:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gregkh@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:bkl/drivers] drivers: Remove BKL from misc_open
Message-ID: <20091014175846.GA3537@elte.hu>
References: <20091010153349.237173041@linutronix.de> <tip-40b798efe3460797a4ac928ee2e038774e2758eb@git.kernel.org> <20091014171249.57dcdcfc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014171249.57dcdcfc@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Wed, 14 Oct 2009 15:47:39 GMT
> tip-bot for Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Commit-ID:  40b798efe3460797a4ac928ee2e038774e2758eb
> > Gitweb:     http://git.kernel.org/tip/40b798efe3460797a4ac928ee2e038774e2758eb
> > Author:     Thomas Gleixner <tglx@linutronix.de>
> > AuthorDate: Sat, 10 Oct 2009 15:35:43 +0000
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Wed, 14 Oct 2009 17:33:32 +0200
> > 
> > drivers: Remove BKL from misc_open
> > 
> > misc_open() is already serialized with misc_mtx. Remove the BKL
> > locking which got there via the BKL pushdown.
> 
> NAK.
> 
> You can't simply assume the mutex is enough - you have to either push 
> it down or review *every* possible called point below the lock_kernel 
> take.
> 
> In this case the open method of the misc devices below sometimes uses 
> the BKL.

We did that and it's safe in nvram.c. If you know an unsafe please let 
us know.

	Ingo
