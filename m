Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbYD2INw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbYD2INw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYD2INg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:13:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56241 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbYD2INe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:13:34 -0400
Message-ID: <4816D881.8060005@cn.fujitsu.com>
Date: Tue, 29 Apr 2008 16:12:49 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] on memoryless node, /proc/pagetypeinfo is displayed slightly
 funny output.
References: <20080429162859.3540.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080429162859.3540.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote::
> Hi Mel,
> 
> I make patch of solve trivial pagetypeinfo problem.
> please review it.
> 
> 
> =================================================================
> on memoryless node, /proc/pagetypeinfo is displayed slightly funny output.
> this patch fix it.
> 
> 
> output example (header is outputed, but no data is outputed)
> --------------------------------------------------------------
> Page block order: 14
> Pages per block:  16384
> 
> Free pages count per migrate type at order       0      1      2      3      4      5    \
>   6      7      8      9     10     11     12     13     14     15     16
> 
> Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
> Page block order: 14
> Pages per block:  16384
> 
> Free pages count per migrate type at order       0      1      2      3      4      5    \
>   6      7      8      9     10     11     12     13     14     15     16
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Mel Gorman <mel@csn.ul.ie>
> 
> ---
>  mm/vmstat.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: b/mm/vmstat.c
> ===================================================================
> --- a/mm/vmstat.c       2008-04-29 16:48:58.000000000 +0900
> +++ b/mm/vmstat.c       2008-04-29 16:58:33.000000000 +0900
> @@ -638,6 +638,10 @@ static int pagetypeinfo_show(struct seq_
>  {
>         pg_data_t *pgdat = (pg_data_t *)arg;
> 
> +       /* check memoryless ndoe*/

ndoe -> node ?

