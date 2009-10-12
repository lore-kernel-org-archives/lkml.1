Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbZJLSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbZJLSLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbZJLSLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:11:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757474AbZJLSLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:11:40 -0400
Date: Mon, 12 Oct 2009 11:09:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Ingo Molnar <mingo@elte.hu>, Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-Id: <20091012110954.67d7d8d8.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	<20091012111545.GB8857@elte.hu>
	<1255346731.9659.31.camel@localhost>
	<20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
	<20091012153937.0dcd73e5@marrow.netinsight.se>
	<alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 08:36:38 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I agree with the "save kernel buffer on panic" thing, but I disagree with 
> making it anything new, and hooking into "printk()" or the console 
> subsystem AT ALL. That's just bogus, stupid, and WRONG.
> 
> What you can do is to just flush the 'log_buf' buffer (or as much of it as 
> you want - the buffer may be a megabyte in size, and maybe you only want 
> to flush the last 8kB or something like that) on oops. And _not_ mix this 
> up with anything else.

What he said.  I did it that way in the Digeo kernel back in 2002. 
Worked good.  

Doing it via a console is rather weird.  It will need core kernel
changes to do it properly.

Perhaps oops_enter() is a good place to mark the start of the log, and
flush it within oops_exit().

