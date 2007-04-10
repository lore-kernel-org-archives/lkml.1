Return-Path: <linux-kernel-owner+w=401wt.eu-S1030928AbXDJPxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030928AbXDJPxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030922AbXDJPxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:53:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030928AbXDJPxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:53:39 -0400
Date: Tue, 10 Apr 2007 17:53:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410155314.GA16267@elte.hu>
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com> <20070410134814.GA28016@elte.hu> <m17iskz3i8.fsf@ebiederm.dsl.xmission.com> <20070410150650.GA9946@elte.hu> <m1tzvoxniv.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzvoxniv.fsf@ebiederm.dsl.xmission.com>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > so ... is anyone pursuing this? This would allow us to make 
> > sys_wait4() faster and more scalable: no tasklist_lock bouncing for 
> > example.
> 
> which part?

all of it :) Everything you mentioned makes sense quite a bit. The 
thread signal handling of do_wait was added in a pretty arbitrary 
fashion so i doubt there are strong requirements in that area. Apps 
might have grown to get used to it meanwhile though, so we've got to do 
it carefully.

	Ingo
