Return-Path: <linux-kernel-owner+w=401wt.eu-S935030AbZDHRwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030AbZDHRwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbZDHRwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:52:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:40176 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbZDHRwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:52:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,345,1235980800"; 
   d="scan'208";a="679938580"
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Tony Breeds <tony@bakeyournoodle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Wed, 8 Apr 2009 10:52:03 -0700
Subject: RE: [E1000-devel] [PATCH] Be explict with what we are !'ing in
	ixgbe_sfp_config_module_task()
Thread-Topic: [E1000-devel] [PATCH] Be explict with what we are !'ing in
	ixgbe_sfp_config_module_task()
Thread-Index: Acm4B19uERLsc6jcSvW07n+7qxUg8wAazi6Q
Message-ID: <F169D4F5E1F1974DBFAFABF47F60C10A2572FED3@orsmsx507.amr.corp.intel.com>
References: <75761e1f53ed07c43a977d98b54d6467d8896530.1239165870.git.tony@bakeyournoodle.com>
In-Reply-To: <75761e1f53ed07c43a977d98b54d6467d8896530.1239165870.git.tony@bakeyournoodle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Breeds wrote:
> GCC warns:
> drivers/net/ixgbe/ixgbe_main.c: In function
> 'ixgbe_sfp_config_module_task': 
> drivers/net/ixgbe/ixgbe_main.c:3920: warning: suggest parentheses
> around operand of '!' or change '&' to '&&' or '!' to '~' 
> 
> Which I think is right.  Bracket to remove ambiguity.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> ---
>  drivers/net/ixgbe/ixgbe_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ixgbe/ixgbe_main.c
> b/drivers/net/ixgbe/ixgbe_main.c 
> index 9ef128a..9099634 100644
> --- a/drivers/net/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ixgbe/ixgbe_main.c
> @@ -3917,7 +3917,7 @@ static void ixgbe_sfp_config_module_task(struct
>  	work_struct *work) }
>  	hw->mac.ops.setup_sfp(hw);
> 
> -	if (!adapter->flags & IXGBE_FLAG_IN_SFP_LINK_TASK)
> +	if (!(adapter->flags & IXGBE_FLAG_IN_SFP_LINK_TASK))
>  		/* This will also work for DA Twinax connections */
>  		schedule_work(&adapter->multispeed_fiber_task);
>  	adapter->flags &= ~IXGBE_FLAG_IN_SFP_MOD_TASK;

you're extremely correct, thanks!

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>