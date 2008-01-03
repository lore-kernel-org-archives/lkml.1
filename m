Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbYACOGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbYACOGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYACOGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:06:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47207 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYACOGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:06:02 -0500
Date: Thu, 3 Jan 2008 15:05:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [x86] kernel/audit.c cleanup according to checkpatch.pl
Message-ID: <20080103140549.GA19363@elte.hu>
References: <20080103111925.GC8046@cvg> <20080103112957.GA14693@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080103112957.GA14693@lazybastard.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jörn Engel <joern@logfs.org> wrote:

> > -		       "audit: audit_lost=%d audit_rate_limit=%d audit_backlog_limit=%d\n",
> > +		       "audit: audit_lost=%d audit_rate_limit=%d "
> > +		       "audit_backlog_limit=%d\n",
> >  		       atomic_read(&audit_lost),
> >  		       audit_rate_limit,
> >  		       audit_backlog_limit);
> 
> This hunk is a bit questionable.  It can easily deceive a reader to 
> assume two seperate lines printed out and sometimes defeats grepping 
> for printk output to find the code generating the message.

not to make a big issue out of this, but when was the last time you 
tried to grep this way:

  grep -E "audit_rate_limit=[0-9]+ audit_backlog" */*.c

?

That's pretty much the only grep pattern that would break. People 
usually grep on the constant portion of the string, so breaking up a 
line along a variable boundary is perfectly okay.

	Ingo
