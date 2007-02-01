Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXBAWYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXBAWYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbXBAWYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:24:12 -0500
Received: from kanga.kvack.org ([66.96.29.28]:36066 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbXBAWYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:24:11 -0500
Date: Thu, 1 Feb 2007 17:23:56 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070201222356.GV1344@kvack.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <20070201130234.GA15257@elte.hu> <5678BC95-E548-414F-85F9-9D6B4DC914EC@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5678BC95-E548-414F-85F9-9D6B4DC914EC@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 01:52:13PM -0800, Zach Brown wrote:
> >let me clarify this: i very much like your AIO patchset in general, in
> >the sense that it 'completes' the AIO implementation: finally  
> >everything
> >can be done via it, greatly increasing its utility and hopefully its
> >penetration. This is the most important step, by far.
> 
> We violently agree on this :).

There is also the old kernel_thread based method that should probably be 
compared, especially if pre-created threads are thrown into the mix.  Also, 
since the old days, a lot of thread scaling issues have been fixed that 
could even make userland threads more viable.

> Would your strategy be to update the syscall implementations to share  
> data in task_struct so that there isn't as significant a change in  
> behaviour?  (sharing current->ioprio, instead if just inheriting it,  
> for example.).  We'd be betting that there would be few of these and  
> that they'd be pretty reasonable to share?

Priorities cannot be shared, as they have to adapt to the per-request 
priority when we get down to the nitty gitty of POSIX AIO, as otherwise 
realtime issues like keepalive transmits will be handled incorrectly.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.
