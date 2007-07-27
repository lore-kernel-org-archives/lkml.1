Return-Path: <linux-kernel-owner+w=401wt.eu-S936903AbXG0Ocx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936903AbXG0Ocx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933080AbXG0Ocq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:32:46 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:50488 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291AbXG0Ocp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:32:45 -0400
Subject: Re: [patch][rfc] 2.6.23-rc1 mm: NUMA replicated pagecache
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Joachim Deguara <joachim.deguara@amd.com>,
       Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <20070727084252.GA9347@wotan.suse.de>
References: <20070727084252.GA9347@wotan.suse.de>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 27 Jul 2007 10:30:47 -0400
Message-Id: <1185546647.5069.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 10:42 +0200, Nick Piggin wrote:
> Hi,
> 
> Just got a bit of time to take another look at the replicated pagecache
> patch. The nopage vs invalidate race and clear_page_dirty_for_io fixes
> gives me more confidence in the locking now; the new ->fault API makes
> MAP_SHARED write faults much more efficient; and a few bugs were found
> and fixed.
> 
> More stats were added: *repl* in /proc/vmstat. Survives some kbuilding
> tests...
> 
> --
> 
> Page-based NUMA pagecache replication.
<snip really big patch!>

Hi, Nick.

Glad to see you're back on this.  It's been on my list, but delayed by
other patch streams...

As I mentioned to you in prior mail, I want to try to integrate this
atop my "auto/lazy migration" patches, such that when a task moves to a
new node, we remove just that task's pte ref's to page cache pages
[along with all refs to anon pages, as I do now] so that the task will
take a fault on next touch and either use an existing local copy or
replicate the page at that time.  Unfortunately, that's in the queue
behind the memoryless node patches and my stalled shared policy patches,
among other things :-(.

Also, what kernel is this patch against?  Diffs just say "linux-2.6".
Somewhat ambiguous...

Lee

