Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbXEJHdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbXEJHdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXEJHdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:33:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbXEJHdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:33:14 -0400
Date: Thu, 10 May 2007 00:33:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002 of 2] md: Improve the is_mddev_idle test
Message-Id: <20070510003304.c5fc35d2.akpm@linux-foundation.org>
In-Reply-To: <1070510062231.20403@suse.de>
References: <20070510161940.20204.patches@notabene>
	<1070510062231.20403@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 16:22:31 +1000 NeilBrown <neilb@suse.de> wrote:

> The test currently looks for any (non-fuzz) difference, either
> positive or negative.  This clearly is not needed.  Any non-sync
> activity will cause the total sectors to grow faster than the sync_io
> count (never slower) so we only need to look for a positive differences.
> 
> ...
>
> --- .prev/drivers/md/md.c	2007-05-10 15:51:54.000000000 +1000
> +++ ./drivers/md/md.c	2007-05-10 16:05:10.000000000 +1000
> @@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
>  		 *
>  		 * Note: the following is an unsigned comparison.
>  		 */
> -		if ((curr_events - rdev->last_events + 4096) > 8192) {
> +		if ((long)curr_events - (long)rdev->last_events > 4096) {
>  			rdev->last_events = curr_events;
>  			idle = 0;

In which case would unsigned counters be more appropriate?
