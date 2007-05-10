Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbXEJXkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbXEJXkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbXEJXkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:40:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409AbXEJXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:40:44 -0400
Date: Thu, 10 May 2007 16:40:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomas Janousek <tjanouse@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
Subject: Re: [PATCH] Introduce boot based time
Message-Id: <20070510164028.c38bef7b.akpm@linux-foundation.org>
In-Reply-To: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
References: <1178302732.5929.23.camel@localhost.localdomain>
	<3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 19:10:25 +0200
Tomas Janousek <tjanouse@redhat.com> wrote:

> The commits
>   411187fb05cd11676b0979d9fbf3291db69dbce2 (GTOD: persistent clock support)
>   c1d370e167d66b10bca3b602d3740405469383de (i386: use GTOD persistent clock
>     support)
> changed the monotonic time so that it no longer jumps after resume, but it's
> not possible to use it for boot time and process start time calculations then.
> Also, the uptime no longer increases during suspend.
> 
> I add a variable to track the wall_to_monotonic changes, a function to get the
> real boot time and a function to get the boot based time from the monotonic
> one.

From: Andrew Morton <akpm@linux-foundation.org>

- I don't think those sybols are needed in modules.

- Document total_sleep_time units (would have been better to call it
  total_sleep_time_secs, perhaps).

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Tomas Janousek <tjanouse@redhat.com>
Cc: Tomas Smetana <tsmetana@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/time.h~introduce-boot-based-time-fix include/linux/time.h
diff -puN kernel/time/timekeeping.c~introduce-boot-based-time-fix kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~introduce-boot-based-time-fix
+++ a/kernel/time/timekeeping.c
@@ -46,7 +46,7 @@ EXPORT_SYMBOL(xtime_lock);
  */
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-static unsigned long total_sleep_time;
+static unsigned long total_sleep_time;		/* seconds */
 
 EXPORT_SYMBOL(xtime);
 
@@ -503,8 +503,6 @@ void getboottime(struct timespec *ts)
 		- wall_to_monotonic.tv_nsec);
 }
 
-EXPORT_SYMBOL(getboottime);
-
 /**
  * monotonic_to_bootbased - Convert the monotonic time to boot based.
  * @ts:		pointer to the timespec to be converted
@@ -513,5 +511,3 @@ void monotonic_to_bootbased(struct times
 {
 	ts->tv_sec += total_sleep_time;
 }
-
-EXPORT_SYMBOL(monotonic_to_bootbased);
_

