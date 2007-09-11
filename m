Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbXIKFOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbXIKFOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 01:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbXIKFOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 01:14:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408AbXIKFOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 01:14:22 -0400
Date: Mon, 10 Sep 2007 22:13:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Dave Airlie <airlied@linux.ie>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33
Message-Id: <20070910221316.d31af0dd.akpm@linux-foundation.org>
In-Reply-To: <20070906012852.GA8058@zhen-devel.sh.intel.com>
References: <20070905071152.GA5817@zhen-devel.sh.intel.com>
	<20070905081937.35965e97.randy.dunlap@oracle.com>
	<20070906012852.GA8058@zhen-devel.sh.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Sep 2007 09:28:52 +0800 Zhenyu Wang <zhenyu.z.wang@intel.com> wrote:

> On 2007.09.05 08:19:37 +0000, Randy Dunlap wrote:
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> Thanks Randy. Here's updated patch with typo and tab style
> fixed. I misused x style.
> 
> Subject: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33
> 
> G33 GTT stolen memory is below graphics data
> stolen memory and be seperate, so don't subtract
> it in stolen mem counting.
> 
> Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
> ---
>  drivers/char/agp/intel-agp.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index 2c9ca2c..581f922 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -506,6 +506,11 @@ static void intel_i830_init_gtt_entries(void)
>  			break;
>  		}
>  	} else {
> +		/* G33's GTT stolen memory is separate from gfx data
> +		 * stolen memory.
> +		 */
> +		if (IS_G33)
> +			size = 0;
>  		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
>  		case I855_GMCH_GMS_STOLEN_1M:
>  			gtt_entries = MB(1) - KB(size);

When looking at a "fix" I need to work out whether it might be needed in
2.6.23.  But your description of this patch didn't describe the problem
which it fixes in a way which allows me to decide this.


