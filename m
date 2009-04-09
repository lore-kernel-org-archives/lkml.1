Return-Path: <linux-kernel-owner+w=401wt.eu-S935083AbZDIQVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935083AbZDIQVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759744AbZDIQUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:20:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:27529 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953AbZDIQUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:20:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,161,1239001200"; 
   d="scan'208";a="505050732"
Subject: Re: [PATCH] Allow deferrable timers for intervals tv2-tv5 to be
 deferred
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49DE0C36.4070507@ti.com>
References: <49DE0C36.4070507@ti.com>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 09:18:31 -0700
Message-Id: <1239293911.4529.7144.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 07:54 -0700, Jon Hunter wrote:
> In the current kernel implementation only kernel timers for time 
> interval tv1 are being deferred. This patch allows any timer that is 
> configured as deferrable to be defer regardless of time interval.
> 
> This patch was previously discussed on another the thread [1] and Ack'ed 
>   by Venki Pallipadi the author of the original deferrable timer patch.
> 
> Venki, could you also ack this patch for confirmation?
> 
> Cheers
> Jon
> 
> [1] http://marc.info/?l=linux-kernel&m=123196343531966&w=2
> 
> 

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

> Signed-off-by: Jon Hunter <jon-hunter@ti.com>
> ---
>   kernel/timer.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index b455556..6ab6e96 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1012,6 +1012,9 @@ cascade:
>   		index = slot = timer_jiffies & TVN_MASK;
>   		do {
>   			list_for_each_entry(nte, varp->vec + slot, entry) {
> +				if (tbase_get_deferrable(nte->base))
> +					continue;
> +
>   				found = 1;
>   				if (time_before(nte->expires, expires))
>   					expires = nte->expires;

