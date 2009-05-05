Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZEEE7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZEEE7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZEEE7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:59:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:57659 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbZEEE7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oRoqmOSv7So0J0M/IFPxFoY7Cjebi5cpwy+OBKnNCR0gtpd0/9mssBDB5JrsgkVdVs
         IQrir2gjyhyP4AKS/40D+fBKZWLs0rrO0hKj1Q28yPMoAPkD9irj2sZLOT7c3o644iQA
         bybQNjobHgZHG717Q+ANLyESzW1nnJzclVr4k=
Subject: Re: [PATCH 0/2][GIT PULL] tracing/filters: adjustements for strings
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>
In-Reply-To: <alpine.DEB.2.00.0905040937350.3785@gandalf.stny.rr.com>
References: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.0905040937350.3785@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 04 May 2009 23:59:09 -0500
Message-Id: <1241499549.6825.4.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-05-04 at 09:42 -0400, Steven Rostedt wrote:
> 
> On Sun, 3 May 2009, Frederic Weisbecker wrote:
> 
> > Hi,
> > 
> > The following patchset includes two little peas of features
> > for tracing filters, making them able to filter every kind of strings.
> > 
> > Now I can do this:
> > 
> > cd /debug/tracing
> > echo > trace
> > echo stacktrace > trace_options
> > 
> > cd events/lockdep
> > echo 'name == "&REISERFS_SB(s)->lock" && wait_usec > 0' > lock_acquired/filter
> > 
> > echo 1 > lock_acquired/enable
> > sleep 1
> > echo 0 > lock_acquired/enable
> > 
> > cat trace
> > 
> >  # tracer: nop
> >  #
> >  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> >  #              | |       |          |         |
> >            <...>-6464  [000]   327.448232: lock_acquired: &REISERFS_SB(s)->lock (25058.984 us)
> >            <...>-6464  [000]   327.448233: 
> >  <= reiserfs_get_block
> >  <= __block_prepare_write
> >  <= block_write_begin
> >  <= reiserfs_write_begin
> >  <= generic_file_buffered_write
> >  <= __generic_file_aio_write_nolock
> >  <= generic_file_aio_write
> >            <...>-6470  [000]   327.448422: lock_acquired: &REISERFS_SB(s)->lock (25112.702 us)
> >            <...>-6470  [000]   327.448425: 
> >  <= reiserfs_update_sd_size
> >  <= reiserfs_write_end
> >  <= generic_file_buffered_write
> >  <= __generic_file_aio_write_nolock
> >  <= generic_file_aio_write
> >  <= do_sync_write
> >  <= reiserfs_file_write
> > 
> > 
> > Tom, your filter framework is awesome and very useful!
> > Thanks :-)
> 
> I totally agree, and also like Frederic's changes.
> 
> But...
> 
> 
> This is all useless unless people know it exists and more importantly, how 
> to use it.
> 
> Ted Tso already started a Documentation/trace/events.txt. We need to add 
> documentation of this feature either in Doc../trace/events.txt or add a 
> new file called Doc../trace/filters.txt.  Probably would be better to add 
> a separate file, and add a "See filters.txt" in events.txt.
> 
> Tom or Frederic, could either of you write something up? I could when I 
> have time. The git logs seems to be pretty good at explaining it.
> 

Sure, I'll write something up and put it in Doc../trace/filters.txt.

Tom

> Thanks,
> 
> -- Steve
> 

