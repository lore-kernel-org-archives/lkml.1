Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZLHNaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZLHNaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 08:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZLHNaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 08:30:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbZLHNaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 08:30:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=EJ3mDL9EkcAA:10 a=Q5hZTJsFVgofa8ECl_YA:9 a=9LPDBi0A9ZEiMLM8Q5XNMdq5PAMA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 05/13] ftrace: Call trace_parser_clear() properly
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1E2482.8040203@cn.fujitsu.com>
References: <4B1DC476.3030700@cn.fujitsu.com>
	 <4B1DC4D2.3000406@cn.fujitsu.com> <20091208094825.GA5035@nowhere>
	 <4B1E2482.8040203@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 08 Dec 2009 08:28:25 -0500
Message-Id: <1260278905.2165.20.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 18:03 +0800, Li Zefan wrote:

> > 
> > I'm missing something. How that can happen. Anytime we reopen
> > the file, the parser is re-allocated.
> > 
> 
> It happened at file closing..
> 
> static int
> ftrace_regex_release(struct inode *inode, struct file *file, int enable)
> {
> 	...
>         parser = &iter->parser;
>         if (trace_parser_loaded(parser)) {
>                 parser->buffer[parser->idx] = 0;
> 		/* here ! */
>                 ftrace_match_records(parser->buffer, parser->idx, enable);
>         }
> 	...
> }
> 
> > I guess that happens if you open in rw mode? But not using the
> > example in the changelog?
> 
> I've confirmed that example I was using can reveal this bug.

This explanation should have been in the change log. I'll add it.

Thanks,

-- Steve


