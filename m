Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbZEKMmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbZEKMmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbZEKMkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:40:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34000 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758614AbZEKMkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:40:51 -0400
Date: Mon, 11 May 2009 14:40:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/events: simplify system_enable_read()
Message-ID: <20090511124043.GI13954@elte.hu>
References: <4A03998E.3020503@cn.fujitsu.com> <4A0399A5.2080603@cn.fujitsu.com> <20090508155207.50727920.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508155207.50727920.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 08 May 2009 10:32:05 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > A smarter way to figure out the output of an enable file.
> > 
> > [ Impact: clean up ]
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  kernel/trace/trace_events.c |   40 ++++++----------------------------------
> >  1 files changed, 6 insertions(+), 34 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index 45f1099..df394bc 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -414,10 +414,11 @@ static ssize_t
> >  system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
> >  		   loff_t *ppos)
> >  {
> > +	const char set_to_char[4] = { '?', '0', '1', 'X' };
> 
> I always worry when I see this, but gcc does manage to add the missing
> `static' all by itself.  For which versions of gcc that is true I don't
> know.
> 
> > +	buf[0] = set_to_char[set];
> 
> Meh.  Real men do
> 
> 	buf[0] = "?01X"[set];

heh. That deserves a commit ...

	Ingo
