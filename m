Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZEDNmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZEDNmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZEDNmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:42:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZEDNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:42:14 -0400
Date: Mon, 4 May 2009 09:42:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/2][GIT PULL] tracing/filters: adjustements for
 strings
In-Reply-To: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0905040937350.3785@gandalf.stny.rr.com>
References: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 May 2009, Frederic Weisbecker wrote:

> Hi,
> 
> The following patchset includes two little peas of features
> for tracing filters, making them able to filter every kind of strings.
> 
> Now I can do this:
> 
> cd /debug/tracing
> echo > trace
> echo stacktrace > trace_options
> 
> cd events/lockdep
> echo 'name == "&REISERFS_SB(s)->lock" && wait_usec > 0' > lock_acquired/filter
> 
> echo 1 > lock_acquired/enable
> sleep 1
> echo 0 > lock_acquired/enable
> 
> cat trace
> 
>  # tracer: nop
>  #
>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>  #              | |       |          |         |
>            <...>-6464  [000]   327.448232: lock_acquired: &REISERFS_SB(s)->lock (25058.984 us)
>            <...>-6464  [000]   327.448233: 
>  <= reiserfs_get_block
>  <= __block_prepare_write
>  <= block_write_begin
>  <= reiserfs_write_begin
>  <= generic_file_buffered_write
>  <= __generic_file_aio_write_nolock
>  <= generic_file_aio_write
>            <...>-6470  [000]   327.448422: lock_acquired: &REISERFS_SB(s)->lock (25112.702 us)
>            <...>-6470  [000]   327.448425: 
>  <= reiserfs_update_sd_size
>  <= reiserfs_write_end
>  <= generic_file_buffered_write
>  <= __generic_file_aio_write_nolock
>  <= generic_file_aio_write
>  <= do_sync_write
>  <= reiserfs_file_write
> 
> 
> Tom, your filter framework is awesome and very useful!
> Thanks :-)

I totally agree, and also like Frederic's changes.

But...


This is all useless unless people know it exists and more importantly, how 
to use it.

Ted Tso already started a Documentation/trace/events.txt. We need to add 
documentation of this feature either in Doc../trace/events.txt or add a 
new file called Doc../trace/filters.txt.  Probably would be better to add 
a separate file, and add a "See filters.txt" in events.txt.

Tom or Frederic, could either of you write something up? I could when I 
have time. The git logs seems to be pretty good at explaining it.

Thanks,

-- Steve

