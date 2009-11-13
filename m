Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZKMSi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZKMSi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbZKMSiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:38:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbZKMSiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:38:23 -0500
Message-ID: <4AFDA724.7010200@redhat.com>
Date: Fri, 13 Nov 2009 13:36:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH] vmscan: Stop kswapd waiting on congestion when the min
 watermark is not being met
References: <20091113142608.33B9.A69D9226@jp.fujitsu.com> <20091113135443.GF29804@csn.ul.ie> <20091114023138.3DA5.A69D9226@jp.fujitsu.com> <20091113181557.GM29804@csn.ul.ie>
In-Reply-To: <20091113181557.GM29804@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 01:15 PM, Mel Gorman wrote:
> If reclaim fails to make sufficient progress, the priority is raised.
> Once the priority is higher, kswapd starts waiting on congestion.  However,
> if the zone is below the min watermark then kswapd needs to continue working
> without delay as there is a danger of an increased rate of GFP_ATOMIC
> allocation failure.
>
> This patch changes the conditions under which kswapd waits on
> congestion by only going to sleep if the min watermarks are being met.
>
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 90b11e4..bc09547 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -685,6 +685,7 @@ static const char * const vmstat_text[] = {
>   	"kswapd_inodesteal",
>   	"kswapd_slept_prematurely_fast",
>   	"kswapd_slept_prematurely_slow",
> +	"kswapd_no_congestion_wait",
>   	
>    
Perhaps better named "kswapd_skip_congestion_wait" ?

Other than that, the patch looks good to me.

Reviewed-by: Rik van Riel <riel@redhat.com>

