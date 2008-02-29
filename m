Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYB2IGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYB2IGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 03:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYB2IGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 03:06:36 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756693AbYB2IGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 03:06:34 -0500
Date: Fri, 29 Feb 2008 00:05:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: trivial clean up to zlc_setup
Message-Id: <20080229000544.5cf2667e.akpm@linux-foundation.org>
In-Reply-To: <20080229151057.66ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080229151057.66ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 15:19:39 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> I found very small bug during review mel's 2 zonelist patch series.
> 
> this patch is trivial clean up.
> jiffies subtraction may cause overflow problem.
> it shold be used time_after().
> 
> Thanks.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> CC: Paul Jackson <pj@sgi.com>
> ---
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c   2008-02-18 17:17:25.000000000 +0900
> +++ b/mm/page_alloc.c   2008-02-29 15:17:03.000000000 +0900
> @@ -1294,7 +1294,7 @@ static nodemask_t *zlc_setup(struct zone
>         if (!zlc)
>                 return NULL;
> 
> -       if (jiffies - zlc->last_full_zap > 1 * HZ) {
> +       if (time_after(jiffies, zlc->last_full_zap + HZ)) {
>                 bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
>                 zlc->last_full_zap = jiffies;
>         }

That's a mainline bug.  Also present in 2.6.24, maybe earlier.

But it's a minor one - we'll fix it up one second later (yes?)
