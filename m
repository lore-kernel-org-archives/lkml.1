Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbYBACCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbYBACCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYBACB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:01:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753241AbYBACB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:01:58 -0500
Date: Thu, 31 Jan 2008 18:02:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Liam Howlett <howlett@gmail.com>
Subject: Re: Pull request: TASK_KILLABLE
Message-Id: <20080131180205.20e7dece.akpm@linux-foundation.org>
In-Reply-To: <1201830304.3087.2.camel@heimdal.trondhjem.org>
References: <20080129000447.GC31101@parisc-linux.org>
	<alpine.LFD.1.00.0801292237480.3505@www.l.google.com>
	<20080131234504.GB25967@parisc-linux.org>
	<alpine.LFD.1.00.0802011146180.3198@www.l.google.com>
	<1201830304.3087.2.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 20:45:04 -0500 Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> 
> On Fri, 2008-02-01 at 11:48 +1100, Linus Torvalds wrote:
> > 
> > On Thu, 31 Jan 2008, Matthew Wilcox wrote:
> > > 
> > > To allow tasks to be interrupted by fatal signals, we introduce a new
> > > TASK_* bit; TASK_WAKEKILL.  We also add a predicate fatal_signal_pending;
> > > the counterpart of signal_pending().  Then we add killable versions
> > > of lock_page(), mutex_lock(), schedule_timeout(), wait_event(), and
> > > wait_for_completion().  Finally, we can make the NFS 'intr' mount option
> > > a no-op.
> > 
> > Ok, I've pulled this. It conflicted with some NFS changes, but I did what 
> > appeared to be the obvious conflict resolution, and it all at least 
> > compiles and it looked sane to me. But I don't have NFS enabled normally, 
> > and I certainly don't have a good way to test with my laptop while in 
> > Melbourne, so Trond/Matthew, can you please double- and triple-check my 
> > merge?
> 
> Hmm... The current code won't compile as a module. We're at least going
> to require something like the attached patch.
> 
> ...
> +EXPORT_SYMBOL_GPL(__fatal_signal_pending);
>

No such export was needed in the patches which I added to -mm.  So
something changed between then and now.

And going back through the mailing list all I can find is a series of five
patches in October - it's unclear where and when the other 17 were
reviewed, if they were.

Sorry, but I don't think this work has been suitably reviewed and tested.

