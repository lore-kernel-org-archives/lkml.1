Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZECI1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZECI1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 04:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZECI1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 04:27:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52871 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZECI1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 04:27:00 -0400
Date: Sun, 3 May 2009 10:26:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH 0/2][GIT PULL] tracing/filters: adjustements for strings
Message-ID: <20090503082645.GA27707@elte.hu>
References: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

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

Seconded :)

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

Pulled, thanks Frederic!

	Ingo
