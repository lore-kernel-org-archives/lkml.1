Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZJ0SVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZJ0SVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZJ0SVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:21:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:49142 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbZJ0SVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:21:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,634,1249282800"; 
   d="scan'208";a="204294671"
Subject: Re: [PATCH] [GIT PULL] tracing: allow to change permissions for
 text with dynamic ftrace enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256666023.26028.411.camel@gandalf.stny.rr.com>
References: <1256666023.26028.411.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 27 Oct 2009 11:20:27 -0800
Message-Id: <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 10:53 -0700, Steven Rostedt wrote:
> commit 883242dd0e5faaba041528a9a99f483f2a656c83
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Oct 27 13:15:11 2009 -0400
> 
>     tracing: allow to change permissions for text with dynamic ftrace enabled
>     
>     The commit 74e081797bd9d2a7d8005fe519e719df343a2ba8
>     x86-64: align RODATA kernel section to 2MB with CONFIG_DEBUG_RODATA
>     prevents text sections from becoming read/write using set_memory_rw.
>     
>     The dynamic ftrace changes all text pages to read/write just before
>     converting the calls to tracing to nops, and vice versa.
>     
>     I orginally just added a flag to allow this transaction when ftrace
>     did the change, but I also found that when the CPA testing was running
>     it would remove the read/write as well, and ftrace does not do the text
>     conversion on boot up, and the CPA changes caused the dynamic tracer
>     to fail on self tests.
>     
>     The current solution I have is to simply not to prevent
>     change_page_attr from setting the RW bit for kernel text pages.


Steven, Is it possible for dynamic ftrace to use the kernel identity
mapping instead of the kernel text mapping for converting the tracing
calls to nops etc.

That way, we can still retain large page mappings for kernel text, while
allowing the text to be changed.

I need to think through this to see if there are any subtle issues. What
do you think?

thanks,
suresh

