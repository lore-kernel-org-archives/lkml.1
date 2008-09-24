Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYIXS6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYIXS6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYIXS6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:58:15 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:60714 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIXS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:58:14 -0400
Message-ID: <48DA8DC4.90203@ct.jp.nec.com>
Date: Wed, 24 Sep 2008 11:58:12 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: mingo@elte.hu, macro@linux-mips.org, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] x86: apic - simplify lapic_get_maxlvt
References: <20080924164618.588609232@gmail.com>> <48da6f73.0c07560a.1702.41f4@mx.google.com>
In-Reply-To: <48da6f73.0c07560a.1702.41f4@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Lets use lapic_get_version helper and hide
> register being read. Also it allow us to
> make code a bit tighter.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Index: linux-2.6.git/arch/x86/kernel/apic.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-24 19:17:20.000000000 +0400
> +++ linux-2.6.git/arch/x86/kernel/apic.c	2008-09-24 19:33:31.000000000 +0400
> @@ -309,14 +309,14 @@ int get_physical_broadcast(void)
>   */
>  int lapic_get_maxlvt(void)
>  {
> -	unsigned int v;
> +	unsigned int ver;
>  
> -	v = apic_read(APIC_LVR);
> +	ver = lapic_get_version();
>  	/*
>  	 * - we always have APIC integrated on 64bit mode
>  	 * - 82489DXs do not report # of LVT entries
>  	 */
> -	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
> +	return APIC_INTEGRATED(ver) ? GET_APIC_MAXLVT(ver) : 2;
                                                      ^^^
Hi, is this correct?
Does ver have the full content of apic_read(APIC_LVR)?

thanks,
Hiroshi Shimamoto
