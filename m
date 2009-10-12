Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZJLSi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZJLSi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbZJLSi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:38:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757718AbZJLSi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:38:57 -0400
Date: Mon, 12 Oct 2009 11:36:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-Id: <20091012113647.454fccc5.akpm@linux-foundation.org>
In-Reply-To: <20091012182346.GH17138@elte.hu>
References: <20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
	<20091012153937.0dcd73e5@marrow.netinsight.se>
	<alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	<20091012110954.67d7d8d8.akpm@linux-foundation.org>
	<20091012182346.GH17138@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 20:23:46 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 12 Oct 2009 08:36:38 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > I agree with the "save kernel buffer on panic" thing, but I disagree with 
> > > making it anything new, and hooking into "printk()" or the console 
> > > subsystem AT ALL. That's just bogus, stupid, and WRONG.
> > > 
> > > What you can do is to just flush the 'log_buf' buffer (or as much of it as 
> > > you want - the buffer may be a megabyte in size, and maybe you only want 
> > > to flush the last 8kB or something like that) on oops. And _not_ mix this 
> > > up with anything else.
> > 
> > What he said.  I did it that way in the Digeo kernel back in 2002. 
> > Worked good.
> > 
> > Doing it via a console is rather weird.  It will need core kernel 
> > changes to do it properly.
> > 
> > Perhaps oops_enter() is a good place to mark the start of the log, and 
> > flush it within oops_exit().
> 
> Simplest would be to do the last 2K in oops_exit()? That gives the oops, 
> and the history leading up to it. Since the blocking is 2K, the extra 
> log output is for free.
> 
> (unless the oops is larger than 2K - but that is rather rare.)
> 

Some oops traces can be pretty large.  Perhaps "oops_enter minus 1k up
to oops_exit".

The digeo kernel later got changed to package the oops into a binary
record format for logging to nvram.  iirc that was for space reasons,
and for ease of downstream analysis.

That kernel used to be downloadable but I can't immediately find it. 
Probably not very interesting anyway.

