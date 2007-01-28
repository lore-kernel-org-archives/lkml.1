Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXA1Q0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXA1Q0E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 11:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbXA1Q0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 11:26:04 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:39491
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXA1Q0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 11:26:03 -0500
Date: Sun, 28 Jan 2007 08:25:43 -0800
To: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Cc: "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH 4/7] fs: break the file_list_lock for sb->s_files
Message-ID: <20070128162543.GA718@gnuppy.monkey.org>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120510.090289000@programming.kicks-ass.net> <20070128144358.GC16552@infradead.org> <20070128152106.GA9196@elte.hu> <20070128153006.GB23410@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128153006.GB23410@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 03:30:06PM +0000, Christoph Hellwig wrote:
> On Sun, Jan 28, 2007 at 04:21:06PM +0100, Ingo Molnar wrote:
> > > > sb->s_files is converted to a lock_list. furthermore to prevent the 
> > > > lock_list_head of getting too contended with concurrent add 
> > > > operations the add is buffered in per cpu filevecs.
> > > 
> > > NACK.  Please don't start using lockdep internals in core code.
> > 
> > what do you mean by that?
> 
> struct lock_list is an lockdep implementation detail and should not
> leak out and be used anywhere else.   If we want something similar it
> should be given a proper name and a header of it's own, but I don't
> think it's a valueable abstraction for the core kernel.

Christoph,

"lock list" has nothing to do with lockdep. It's a relatively new
data type used to construct concurrent linked lists using a spinlock
per entry.

bill

