Return-Path: <linux-kernel-owner+w=401wt.eu-S1763938AbXGFRuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763938AbXGFRuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761137AbXGFRu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:50:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:57305 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760967AbXGFRu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:50:29 -0400
Message-ID: <468E8106.8080801@windriver.com>
Date: Fri, 06 Jul 2007 12:51:02 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: kgdb Bad IO access
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <468E4BA5.8010601@imap.cc>
In-Reply-To: <468E4BA5.8010601@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2007 17:50:11.0261 (UTC) FILETIME=[196A5ED0:01C7BFF6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Apart from that, the kernel runs fine, though its subjectively a bit
> sluggish compared to 2.6.22-rc6-mm1 without kgdb. Its uname -a is:
> Linux xenon 2.6.22-rc6-mm1-test4 #10 SMP PREEMPT Thu Jul 5 23:41:32 CEST 2007 i686 i686 i386 GNU/Linux
> I didn't even try to actually do anything with kgdb, though.
>
>   

Do you have something that is more than subjective as a measure?  Some 
app runs slower, or it boots x seconds slower?

The only place I could foresee that kgdb could be eating extra cycles in 
the runtime case is from the die_notifier processing.  Any kind of 
exception such as a page fault, trap etc... will have a few extra ops 
and checks of variables so as to determine if the debugger should take 
the exception.  It looks to me like it would even benefit to add the 
check at the top of the notify hook for kgdb to exit immediately if the 
debugger is not attached.

I have contemplated making some changes to KGDB so as to make the 
registration to the die_notifier to be dynamic with attaching and 
detaching of the debugger.  If this is done, I would also make a change 
to allow for the case where the kernel would wait for the debugger to 
attach on any fatal fault.

Jason.



