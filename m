Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbXCOUwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbXCOUwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbXCOUwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:52:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51564 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753367AbXCOUwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:52:00 -0400
Date: Thu, 15 Mar 2007 13:51:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mundt <lethal@linux-sh.org>
cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/4] Generic quicklist implementation
In-Reply-To: <20070313090546.GA4511@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0703151348370.27391@schroedinger.engr.sgi.com>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
 <20070313071330.4920.54914.sendpatchset@schroedinger.engr.sgi.com>
 <20070313090546.GA4511@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Paul Mundt wrote:

> This doesn't work, and so CONFIG_QUICKLIST is always set. The NR_QUICK
> thing seems a bit backwards anyways, perhaps it would make more sense to
> have architectures set CONFIG_GENERIC_QUICKLIST in the same way that the
> other GENERIC_xxx bits are defined, and then set NR_QUICK based off of
> that. It's obviously going to be 2 or 1 for most people, and x86 seems to
> be the only one that needs 2.

Both i386 and x86_64 currently need 2 and if other arches start using 
quicklists then they would have the same issues. There may be other 
cases in the future where these may be useful. So I think this is too 
inflexible.

> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 7942b33..2f20860 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -163,3 +163,8 @@ config ZONE_DMA_FLAG
>  	default "0" if !ZONE_DMA
>  	default "1"
>  
> +config NR_QUICK
> +	int
> +	depends on GENERIC_QUICKLIST
> +	default "2" if X86
> +	default "1"
> 

Is there a way of checking if a CONFIG_xxx is set to any value?

Then we could do

config QUICKLISTS
	depends on defined(NR_QUICK)

Alternately we could replace #ifdef CONFIG_QUICKLISTS with
#ifdef CONFIG_NR_QUICK ?

