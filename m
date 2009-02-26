Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZBZM3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZBZM3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZBZM3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:29:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52509 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbZBZM3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:29:11 -0500
Date: Thu, 26 Feb 2009 13:28:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/5] [RFC] copy_strtok_from_user
Message-ID: <20090226122859.GD23099@elte.hu>
References: <20090226053240.607719846@goodmis.org> <1235642612.4645.4737.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235642612.4645.4737.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-02-26 at 00:32 -0500, Steven Rostedt wrote:
> > This is the second series of the uaccess code.
> > 
> > Changes in v2:
> > 
> >  - moved probe_kernel_* functions to lib/uaccess.c
> > 
> >  - renamed copy_word_from_user to copy_strtok_from_user.
> > 
> >  - changed copy_strtok_from_user to pass in a delimiter string.
> >    ftrace defines SPACE to be ' \t\r\n'.
> > 
> > Ingo,
> > I added your copy right to lib/uaccess.c since git blame shows you
> > as the author of the probe_kernel_* code. Also, is it OK that I
> > added the "GPL v2" line in that file as well?
> > 
> > Andrew,
> > Since you are, in essence, the memory maintainer, could you give
> > your Acked-by: to the copy_strtok_from_user code.
> > 
> > The probe_kernel code is still EXPORT_SYMBOL_GPL, and I added
> > that too to copy_strtok_from_user. Are there any objections to that?
> 
> I have to ask,..
> 
> cant this be done with a regular copy_from_user() followed by 
> a regular strtok()? Do we really have to combine all that?

yes. Note that strsep() is the preferred API. (in fact it's the 
only such string API that is in the kernel)

	Ingo
