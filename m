Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYAPIpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYAPIpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYAPIou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:44:50 -0500
Received: from smtp.mermit.fi ([194.100.131.6]:41766 "EHLO smtp.mermit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbYAPIot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:44:49 -0500
X-Greylist: delayed 1851 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2008 03:44:48 EST
X-Spam-Flag: NO
X-Spam-Score: -1.024
Message-ID: <478DBCC8.10404@kolumbus.fi>
Date: Wed, 16 Jan 2008 10:14:00 +0200
From: =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: venkatesh.pallipadi@intel.com
CC: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/4] x86: PAT followup - Remove KERNPG_TABLE from pte
 entry
References: <20080116023955.597433000@intel.com> <20080116024111.825025000@intel.com>
In-Reply-To: <20080116024111.825025000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com kirjoitti:
> KERNPG_TABLE was a bug in earlier patch. Remove it from pte.
> pte_val() check is redundant as this routine is called immediately after a
> ptepage is allocated afresh.
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
> Index: linux-2.6.git/arch/x86/mm/init_64.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/mm/init_64.c	2008-01-15 11:02:23.000000000 -0800
> +++ linux-2.6.git/arch/x86/mm/init_64.c	2008-01-15 11:06:37.000000000 -0800
> @@ -541,9 +541,6 @@
>  		if (address >= end)
>  			break;
>  
> -		if (pte_val(*pte))
> -			continue;
> -
>  		/* Nothing to map. Map the null page */
>  		if (!(address & (~PAGE_MASK)) &&
>  		    (address + PAGE_SIZE <= end) &&
> @@ -561,9 +558,9 @@
>  		}
>  
>  		if (exec)
> -			entry = _PAGE_NX|_KERNPG_TABLE|_PAGE_GLOBAL|address;
> +			entry = _PAGE_NX|_PAGE_GLOBAL|address;
>  		else
> -			entry = _KERNPG_TABLE|_PAGE_GLOBAL|address;
> +			entry = _PAGE_GLOBAL|address;
>  		entry &= __supported_pte_mask;
>  		set_pte(pte, __pte(entry));
>  	}
>
>   

Hmm then what's the point of mapping not present 4k pages for valid mem 
here?

--Mika


