Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZEKSkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZEKSkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZEKSk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:40:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbZEKSk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:40:28 -0400
Date: Mon, 11 May 2009 11:31:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: fengguang.wu@intel.com, fweisbec@gmail.com, rostedt@goodmis.org,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       andi@firstfloor.org, mpm@selenic.com, adobriyan@gmail.com,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/8] proc: export more page flags in /proc/kpageflags
Message-Id: <20090511113157.b2c56e70.akpm@linux-foundation.org>
In-Reply-To: <20090511114554.GC4748@elte.hu>
References: <20090508105320.316173813@intel.com>
	<20090508111031.020574236@intel.com>
	<20090508114742.GB17129@elte.hu>
	<20090508132452.bafa287a.akpm@linux-foundation.org>
	<20090509104409.GB16138@elte.hu>
	<20090509222612.887b96e3.akpm@linux-foundation.org>
	<20090511114554.GC4748@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 13:45:54 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > Yes, we could place pagemap's two auxiliary files into debugfs but 
> > it would be rather stupid to split the feature's control files 
> > across two pseudo filesystems, one of which may not even exist.  
> > Plus pagemap is not a kernel debugging feature.
> 
> That's not what i'm suggesting though.
> 
> What i'm suggesting is that there's a zillion ways to enumerate and 
> index various kernel objects, doing that in /proc is fundamentally 
> wrong. And there's no need to create a per PID/TID directory 
> structure in /debug either, to be able to list and access objects by 
> their PID.

The problem with procfs was that it was growing a lot of random
non-process-related stuff.  We never deprecated procfs - we decided
that it should be retained for its original purpose and that
non-process-realted things shouldn't go in there.

The /proc/<pid>/pagemap file clearly _is_ process-related, and
/proc/<pid> is the natural and correct place for it to live.

Yes, sure, there are any number of ways in which that data could be
presented to userspace in other locations and via other means.  But
there would need to be an extraordinarily good reason for violating the
existing paradigm/expectation/etc.


