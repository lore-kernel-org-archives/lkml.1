Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYEMCGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYEMCGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 22:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYEMCGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 22:06:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37687 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbYEMCGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 22:06:46 -0400
Date: Tue, 13 May 2008 11:09:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/4] [mm] buddy page allocator: add tunable big order
 allocation
Message-Id: <20080513110902.80a87ac9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1210588325-11027-2-git-send-email-cooloney@kernel.org>
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
	<1210588325-11027-2-git-send-email-cooloney@kernel.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 18:32:02 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Does this really solve your problem ? possible hang-up is better than
page allocation failure ?

> ---
>  init/Kconfig    |    9 +++++++++
>  mm/page_alloc.c |    2 +-
>  2 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 6135d07..b6ff75b 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -742,6 +742,15 @@ config SLUB_DEBUG
>  	  SLUB sysfs support. /sys/slab will not exist and there will be
>  	  no support for cache validation etc.
>  
> +config BIG_ORDER_ALLOC_NOFAIL_MAGIC
> +	int "Big Order Allocation No FAIL Magic"
> +	depends on EMBEDDED
> +	range 3 10
> +	default 3
> +	help
> +	  Let big-order allocations loop until memory gets free. Specified Value
> +	  expresses the order.
> +
I think it's better to add a text to explain why this is for EMBEDED.

Thanks,
-Kame

