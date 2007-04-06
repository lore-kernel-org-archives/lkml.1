Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbXDFRbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbXDFRbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXDFRbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:31:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43250 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXDFRbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:31:39 -0400
Date: Fri, 6 Apr 2007 19:31:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406173123.GA1875@elte.hu>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com> <20070406154750.GA541@tv-sign.ru> <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org> <20070406172720.GA1147@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406172720.GA1147@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> putting the freshly reaped tasks at the 'head' of the list is just a 
> fancy (and incomplete) way of splitting the list up into two lists, and 
> i'd advocate a clean split. Just like have have split the ptrace_list 
                                          ^---s/have/we
> away from the main list too.

and in this sense your suggestion will happen:

> > I'd almost prefer to just not add kernel threads to any parent 
> > process list *at*all*.

because that way kernel threads will never show up in the to-be-reaped 
list, they'll only show up in the main list that represents the tree of 
tasks.

	Ingo
