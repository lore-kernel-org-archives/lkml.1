Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYFRKH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYFRKH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYFRKHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:07:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbYFRKHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:07:17 -0400
Date: Wed, 18 Jun 2008 12:06:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, torvalds@linux-foundation.org
Subject: Re: [PATCH] shm: Remove silly double assignment
Message-ID: <20080618100624.GE15255@elte.hu>
References: <20080610125338.GB3165@hmsreliant.think-freely.org> <20080611034506.05ad07ae.akpm@linux-foundation.org> <20080611170321.GA23507@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611170321.GA23507@hmsreliant.think-freely.org>
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


* Neil Horman <nhorman@tuxdriver.com> wrote:

> > Not silly, really.  Look:
> > 
> > 	err = -ENOMEM;
> > 	if (expr1)
> > 		goto out;
> > 
> > 	err = -ENOMEM;
> > 	if (expr2)
> > 		goto out;
> > 
> > each of these two units is a separate, self-contained clause.  
> > Removing the second assignment to `err' breaks that separation and 
> > will make one clause undesirably dependent upon the other.
>
> yes, I see that keeping the second assignment lets you insert code in 
> the middle without having up to update afterwards.  I just don't think 
> the redundant assignment is worth keeping just for that purpose.

cleanups is all about having familar, robust, predictable, 
self-contained patterns of code that are easy to recognize, easy to 
review and easy to keep working well.

In this case we've got an admittedly boundary case: removing the 
technically redundant piece of code, while a valid cleanup at first 
sight, makes the code less robust against future changes.

	Ingo
