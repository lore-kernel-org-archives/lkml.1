Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYKJPk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYKJPk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYKJPkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:40:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33363 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYKJPkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:40:46 -0500
Date: Mon, 10 Nov 2008 16:49:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
Message-ID: <20081110154948.GW29626@one.firstfloor.org>
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491843C4.9090306@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  			oprofile_add_sample(regs, i);
> +			/*
> +			 * We need to unmask the apic vector *before*
> +			 * writing reset_value to msr counter
> +			 */
> +			apic_write(APIC_LVTPC, APIC_DM_NMI);
>  			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
>  		}
>  	}
>  
> -	/* Only P6 based Pentium M need to re-unmask the apic vector but it
> -	 * doesn't hurt other P6 variant */
> -	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);

Did you also test if it really needs to be inside the if () or 
just before the wrmsrl? 

-Andi
