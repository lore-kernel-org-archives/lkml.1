Return-Path: <linux-kernel-owner+w=401wt.eu-S1763930AbXJORsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763930AbXJORsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940AbXJORsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:48:20 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:39814 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932813AbXJORsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:48:17 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Mon, 15 Oct 2007 19:48:03 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Barry Kasindorf" <barry.kasindorf@amd.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23] oProfile: op_model_athalon.c support for AMD
 Family10h (Barcelona) Performance Counters
Message-ID: <20071015174802.GS11245@erda.amd.com>
References: <47139CAB.4000107@amd.com>
MIME-Version: 1.0
In-Reply-To: <47139CAB.4000107@amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Oct 2007 17:48:03.0572 (UTC)
 FILETIME=[89075340:01C80F53]
X-WSS-ID: 6B0D785F0601915146-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.07 13:00:27, Barry Kasindorf wrote:
> 
> oProfile Driver Module Patch for AMD Family10h Kernel 2.6.23
> This patch is for controlling the upper 32bits of the event ctrl msrs.
> This includes the upper 4 bits of the event select and the Guest Only 
> and Host Only bits
> This patch is necessary to make Event Based Profiling work reliably on a 
> Family10h processor
> 
> ---
>  op_model_athlon.c |   22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> ---
> 
> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> diff -Naur linux-2.6.23.orig/arch/i386/oprofile/op_model_athlon.c 
> linux-2.6.23.pmc/arch/i386/oprofile/op_model_athlon.c
> --- linux-2.6.23.orig/arch/i386/oprofile/op_model_athlon.c	2007-10-09 
> 16:31:38.000000000 -0400
> +++ linux-2.6.23.pmc/arch/i386/oprofile/op_model_athlon.c	2007-10-15 
> 11:02:39.000000000 -0400

[]

> @@ -70,7 +74,8 @@
>  		if (unlikely(!CTRL_IS_RESERVED(msrs,i)))
>  			continue;
>  		CTRL_READ(low, high, msrs, i);
> -		CTRL_CLEAR(low);
> +		CTRL_CLEAR_LO(low);
> +		CTRL_CLEAR_HI(low);

Should be probably this:

CTRL_CLEAR_HI(high);

>  		CTRL_WRITE(low, high, msrs, i);
>  	}
> 

[]

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


