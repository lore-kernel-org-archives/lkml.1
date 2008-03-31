Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYCaTR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYCaTR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYCaTRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:17:51 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34719 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYCaTRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:17:51 -0400
Date: Mon, 31 Mar 2008 22:17:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mark Lord <lkml@rtr.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git5: Reported regressions from 2.6.24
Message-ID: <20080331191733.GB23259@cs181133002.pp.htv.fi>
References: <200803310228.11027.rjw@sisk.pl> <47F123DF.10204@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47F123DF.10204@rtr.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 01:48:15PM -0400, Mark Lord wrote:
> Rafael,
>
> Add this one to the list?


That's not a regression from 2.6.24


> * * * * *
>
> Subject: + driver-core-fix-uevent-action-string-regression.patch added to -mm tree
> From: akpm
> To: mm-commits
> Date: 28/03/08 07:51 PM
>
> The patch titled
>     driver core: fix uevent action-string regression
> has been added to the -mm tree.  Its filename is
>     driver-core-fix-uevent-action-string-regression.patch
> ...
>
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
> ------------------------------------------------------
> Subject: driver core: fix uevent action-string regression
> From: Mark Lord <lkml@rtr.ca>
>
> On boot, syslog is flooded with "uevent: unsupported action-string;" messages.
> ..
> Mar 28 14:43:29 shrimp kernel: tty ptyqd: uevent: unsupported
> action-string; this will be ignored in a future kernel version
> Mar 28 14:43:29 shrimp kernel: tty ptyqe: uevent: unsupported
> action-string; this will be ignored in a future kernel version
> Mar 28 14:43:29 shrimp kernel: tty ptyqf: uevent: unsupported
> action-string; this will be ignored in a future kernel version
> Mar 28 14:43:29 shrimp kernel: tty ptyr0: uevent: unsupported
> action-string; this will be ignored in a future kernel version
>
>
> These messages are a regression compared with 2.6.24, which did not flood the
> syslog with them.
>
> The actual underlying problem was introduced in 2.6.23, when somebody made the
> string parsing no longer accept nul-terminated strings as a valid input to
> store_uevent().
>
> Eg.  "add\0" was valid prior to 2.6.23, where the code regressed to require
> "add" without the '\0'.
>
> This patch fixes the 2.6.23 / 2.6.24 regressions, by having the code once
> again tolerate the trailing '\0', if present.
>
> According to GregKH, this mainly affects older Ubuntu systems, such as the one
> I have here that requires this fix.
>
> Signed-off-by: Mark Lord <mlord@pobox.com>
> Cc: Greg KH <greg@kroah.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: <stable@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> lib/kobject_uevent.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -puN lib/kobject_uevent.c~driver-core-fix-uevent-action-string-regression lib/kobject_uevent.c
> --- a/lib/kobject_uevent.c~driver-core-fix-uevent-action-string-regression
> +++ a/lib/kobject_uevent.c
> @@ -59,7 +59,7 @@ int kobject_action_type(const char *buf,
> 	enum kobject_action action;
> 	int ret = -EINVAL;
>
> -	if (count && buf[count-1] == '\n')
> +	if (count && (buf[count-1] == '\n' || buf[count-1] == '\0'))
> 		count--;
>
> 	if (!count)
> _
>
> Patches currently in -mm which might be from lkml@rtr.ca are
>
> driver-core-fix-uevent-action-string-regression.patch

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

