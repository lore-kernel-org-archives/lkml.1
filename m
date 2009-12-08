Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZLHLnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZLHLnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZLHLnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:43:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:44171 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZLHLnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AzRylsY2KFN4edJbHzperUPkoRJFATxdYR39sKXsPwclzLCMm9yKUGh8bEHi/i28fK
         SrH1gunTbV7ZA7UGrcEmU3lMffmI2zqiiz8h3KWDtGeX2apyEgQiBxyPe0b1hvZ08+GH
         mVoMMKhRKoRjEZ8RwWqB3tvhdTDcS634oqfM4=
Date: Tue, 8 Dec 2009 12:43:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/13] ftrace: Call trace_parser_clear() properly
Message-ID: <20091208114350.GA5016@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC4D2.3000406@cn.fujitsu.com> <20091208094825.GA5035@nowhere> <4B1E2482.8040203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E2482.8040203@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 06:03:46PM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
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


Aah, ok.

 
> > I guess that happens if you open in rw mode? But not using the
> > example in the changelog?
> 
> I've confirmed that example I was using can reveal this bug.

Yeah indeed.

