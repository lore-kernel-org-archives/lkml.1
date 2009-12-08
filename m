Return-Path: <linux-kernel-owner+w=401wt.eu-S965715AbZLHR5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965715AbZLHR5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 12:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbZLHR5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 12:57:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965695AbZLHR5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 12:57:07 -0500
Date: Tue, 8 Dec 2009 18:51:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091208175110.GB14815@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop> <20091201220847.GA25400@redhat.com> <1260210877.3935.594.camel@laptop> <20091208150417.GA11883@redhat.com> <1260286534.3935.1511.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260286534.3935.1511.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08, Peter Zijlstra wrote:
>
> On Tue, 2009-12-08 at 16:04 +0100, Oleg Nesterov wrote:
> > The
> > problem is, this code was developed out-of-tree. That is why we would
> > like to merge it asap, then do other changes which could be easily
> > reviewed.
> >
> > Now, do you really mean we should throw out the working code, rewrite
> > it avoiding these barriers, and resubmit? Sure, everything is possible.
> > But this means another round of out-of-tree development with unclear
> > results.
>
> Out-of-tree development is bad, it having taken lot of effort is no
> excuse for merging ugly.
>
> Now, I'm not against barriers at all, but code that is as barrier heavy
> as this, with such bad comments and no clear indication it was actually
> worth using so many barriers make me wonder.

Well. First of all, I agree at least partly. If you ask me, I feel
that in any case utrace needs more cleanups (in fact, like almost
any code in kernel) even if we forget about the barriers. In no
way utrace is finished or perfect. I think that Roland won't argue ;)

But. It would be much easier to do the futher development step by
step, patch by patch, which the changelogs, with the possibilty to
have the review. And it is much easier to change the code which is
already used by people. And, cleanups/simplifications are the most
hard part of the development.

However, of course I can't "prove" that the current code is "good
enough" for merging.

> Barriers aren't free either, and having multiple such things in quick
> succession isn't nessecarily faster than a lock, but much less obvious.

It is hardly possible to argue.

Oleg.

