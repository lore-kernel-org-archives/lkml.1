Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882Ab0AMKwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0AMKwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454Ab0AMKwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:52:41 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38300 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0AMKwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:52:39 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ibmphp : read the length of ebda and map entire ebda region
Date: Wed, 13 Jan 2010 16:22:35 +0530
User-Agent: KMail/1.11.2 (Linux/2.6.30.9-90.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org
References: <201001091712.25655.chandru@in.ibm.com> <20100112172640.954027aa.akpm@linux-foundation.org>
In-Reply-To: <20100112172640.954027aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001131622.36362.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010 06:56:40 Andrew Morton wrote:
> 
> Your email client is performing wordwrapping on the patches.

Sorry for this, I changed the word wrap settings of my client

> 
> All the other ioremap() calls are checked for failure, so this one
> should also be checked, no?

Yes, it needs to be checked. thanks for adding the additional check.

> 
> --- a/drivers/pci/hotplug/ibmphp_ebda.c~ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix
> +++ a/drivers/pci/hotplug/ibmphp_ebda.c
> @@ -261,6 +261,8 @@ int __init ibmphp_access_ebda (void)
>  	debug ("returned ebda segment: %x\n", ebda_seg);
>  	
>  	io_mem = ioremap(ebda_seg<<4, 1);
> +	if (!io_mem)
> +		return -ENOMEM;
>  	ebda_sz = readb(io_mem);
>  	iounmap(io_mem);
>  	debug("ebda size: %d(KiB)\n", ebda_sz);
> _
> 

> 
> A kernel oops is somewhat serious.  Would I be correct in assuming that
> this fix is needed in 2.6.32.x and perhaps earlier kernels?

Yes, I just checked with 2.6.30 kernel and the issue exists over there too. So it applies to all older kernels.

Thanks, 
Chandru


