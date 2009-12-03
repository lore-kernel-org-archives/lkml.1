Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZLCXTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZLCXTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZLCXTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:19:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbZLCXTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:19:08 -0500
Date: Thu, 3 Dec 2009 15:19:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: steiner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/2] GRU - function to generate  chipset IPI values
Message-Id: <20091203151912.c99c4173.akpm@linux-foundation.org>
In-Reply-To: <20091203223549.730449000@sgi.com>
References: <20091203223414.393107000@sgi.com>
	<20091203223549.730449000@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009 16:34:15 -0600
steiner@sgi.com wrote:

> From: Jack Steiner <steiner@sgi.com>
> 
> Create a function to generate the value that is written to the UV hub
> MMR to cause an IPI interrupt to be sent. The function will be
> used in the GRU message queue error recovery code that sends IPIs to
> nodes in remote partitions.
> 
> ...
>
> +static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
> +{
> +	return (1UL << UVH_IPI_INT_SEND_SHFT) |
> +			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
> +			(mode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
> +			(vector << UVH_IPI_INT_VECTOR_SHFT);
> +}

You've taken care to avoid a shift overflow of "1", but not of
`apicid', `vector' and `mode'.

Maybe the compiler does that, I forget.


