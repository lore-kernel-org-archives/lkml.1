Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbXCPE3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbXCPE3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 00:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbXCPE3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 00:29:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40930 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbXCPE3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 00:29:10 -0400
Date: Fri, 16 Mar 2007 13:29:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: da-x@monatomic.org, linux-kernel@vger.kernel.org
Subject: Re: thread stacks and strict vm overcommit accounting
Message-Id: <20070316132903.e86c275d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070315110621.9a9defaf.akpm@linux-foundation.org>
References: <20070313163320.GA28104@localdomain>
	<20070315110621.9a9defaf.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 11:06:21 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > On Tue, 13 Mar 2007 18:33:20 +0200 Dan Aloni <da-x@monatomic.org> wrote:
> > Hello,
> > 
> > This question is relevent to 2.6.20.
> > 
> > I noticed that if the RSS for the stack size is say, 8MB, running
> > a single-threaded process doesn't incur an increase of 8MB to
> > Committed_AS (/proc/meminfo).
> > 
> > However, on multi-threaded apps linked with pthread (on Debian
> > Etch with 2.6.20 vanilla x86_64), every thread will incur the
> > the specified maximum stack size RSS (assuming that you use
> > the default attr). In other words, it appears that vm accounting
> > works differently in that case.
> > 
> > Is this the intended behaviour?
> 
> That sounds like a bug to me.

AFAIK, "main" thread's stack is marked as VM_GROWS?? and its size can be
changed dynamically. "other" threads' stack are alloced by mmap (or malloc maybe)
and it never grows. This is difference between multi-thread and single thread.

So, you should be carefull to the size of stack when you use multi-threaded apps
and vm_overcommit_ratio at the same time. Because MAP_NORESERVE is accounted
if sysctl_overcommit_memory == OVERCOMMIT_NEVER, a program like java will fail
to create a new thread sometimes.

I have no good idea to fix this difference, sorry.

-Kame

