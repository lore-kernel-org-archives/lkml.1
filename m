Return-Path: <linux-kernel-owner+w=401wt.eu-S966480AbXHIPco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966480AbXHIPco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965947AbXHIPap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:30:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35845 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965892AbXHIPan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:30:43 -0400
Subject: Re: 2.6.23-rc2-mm1: hang, prop_norm_single involved
From: Peter Zijlstra <peterz@infradead.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, apw <apw@shadowen.org>
In-Reply-To: <1186663502.20108.28.camel@twins>
References: <20070809111044.GA6575@localhost.sw.ru>
	 <1186663502.20108.28.camel@twins>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 17:30:32 +0200
Message-Id: <1186673432.20108.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 14:45 +0200, Peter Zijlstra wrote:
> On Thu, 2007-08-09 at 15:10 +0400, Alexey Dobriyan wrote:
> > LTP run reproducably hangs during rwtest01 test
> > rwtest -N rwtest01 -c -q -i 60s -f sync 10%25000:rs-sync=$$
> > Calltrace is always the same:
> > 

> [root@opteron ~]# PATH=/testcases/bin/:$PATH /testcases/bin/rwtest -N rwtest01 -c -q -i 60s -f sync 10%25000:rs-sync=$$
> rwtest01    1  PASS  :  Test passed
> [root@opteron ~]# PATH=/testcases/bin/:$PATH /testcases/bin/rwtest -N rwtest01 -c -q -i 60s -f sync 10%25000:rs-sync=$$
>    
> I can reproduce, but not always.
> 
> Also, since the task->dirties member is initialized in fork.c this
> should either _always_ happen or never. So this does point to some
> memory corruption, ->dirties is the very last member of the task struct.
> 
> /me goes try with slab_debug,...

to no avail, banging head against the wall what is happening here.

Andrew, could you:

# mm-dirty-balancing-for-tasks.patch

while I try to figure this one out?

That seems to make the unhappies I could reproduce here go away.

