Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZEDErf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZEDErf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 00:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZEDErZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 00:47:25 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:2384 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZEDErZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 00:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gaw2VckB+CZGDvJx0qTgyza8SGlJWf0Zx8/t8JJP3KOwp/JMwVFDN8q73KmcCwjEzO
         ZDydbB901yaKCEuwmCxyyDo+5zmbZ8oNDrIJKY7H93Ml5PtvSJeES5iMUOsRVmjTGl5t
         pGoogtyWS/LOR+iRtfybtV+Tuv/sVBjMr7IKM=
Subject: Re: [PATCH 0/2][GIT PULL] tracing/filters: adjustements for strings
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>
In-Reply-To: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
References: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Sun, 03 May 2009 23:47:22 -0500
Message-Id: <1241412442.5844.10.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2009-05-03 at 03:50 +0200, Frederic Weisbecker wrote:
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

Thanks!  And thanks for adding these new useful features, too - the
patches look good to me...

Acked-by: Tom Zanussi <tzanussi@gmail.com>

Tom

> 
> Frederic.
> ---
> 
> The following changes since commit a0e39ed378fb6ba916522764cd508fa7d42ad495:
>   Heiko Carstens (1):
>         tracing: fix build failure on s390
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/filters
> 
> Frederic Weisbecker (2):
>       tracing/filters: support for filters of dynamic sized arrays
>       tracing/filters: support for operator reserved characters in strings
> 
>  kernel/trace/trace_events_filter.c |   54 ++++++++++++++++++++++++++++++++++--
>  1 files changed, 51 insertions(+), 3 deletions(-)

