Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbZKYQAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbZKYQAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZKYQAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:00:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34661 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbZKYQAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:00:47 -0500
Date: Wed, 25 Nov 2009 17:00:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091125160032.GB9456@elte.hu>
References: <20091124200220.GA5828@redhat.com>
 <87my2bwtno.fsf@basil.nowhere.org>
 <20091124204152.GA9131@redhat.com>
 <20091124212619.GB29096@one.firstfloor.org>
 <20091124214450.GA12828@redhat.com>
 <20091125084617.GD29096@one.firstfloor.org>
 <20091125145556.GA5394@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125145556.GA5394@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Much better. But in this case please note that most of tracehooks just 
> do:
> 
> 		if (unlikely(task_utrace_flags(current) & SOME_EVENT))
> 			utrace_report_some_event();
> 
> I really don't understand why we shouldn't have (trivial!) helpers for 
> this. (As for naming - personally I do not care at all ;)

We prefer helpers in most such cases - especially when in the normal 
case the helper has no side effects - as here. Then we want to compress 
all such reporting/callback as much as possible.

Using helpers to abstract away functionality is one of the basic 
elements of writing clean kernel code.

	Ingo
