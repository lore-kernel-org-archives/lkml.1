Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZDTA1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZDTA1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZDTA11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:27:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39125 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZDTA10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:27:26 -0400
Message-ID: <49EBC150.2020407@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 09:26:56 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [1/28] x86: Fix panic with interrupts off (needed for
 MCE)
References: <20090407507.636692542@firstfloor.org> <20090407150740.D95E51D046D@basil.firstfloor.org>
In-Reply-To: <20090407150740.D95E51D046D@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I put the reboot vector into the highest priority bucket
> of the APIC vectors and moved the 64bit UV_BAU message
> down instead into the next lower priority.

I had forgotten to point this...

> @@ -88,12 +88,14 @@
>  #define THERMAL_APIC_VECTOR		0xfa
>  
>  #ifdef CONFIG_X86_32
> -/* 0xf8 - 0xf9 : free */
> +/* 0xf9 : free */
>  #else
>  # define THRESHOLD_APIC_VECTOR		0xf9
> -# define UV_BAU_MESSAGE			0xf8
>  #endif
>  
> +#define REBOOT_VECTOR			0xf8
> +
> +
>  /* f0-f7 used for spreading out TLB flushes: */
>  #define INVALIDATE_TLB_VECTOR_END	0xf7
>  #define INVALIDATE_TLB_VECTOR_START	0xf0
> @@ -116,6 +118,8 @@
>   */
>  #define GENERIC_INTERRUPT_VECTOR	0xed
>  
> +#define UV_BAU_MESSAGE			0xec
> +
>  /*
>   * First APIC vector available to drivers: (vectors 0x30-0xee) we
>   * start at 0x31(0x41) to spread out vectors evenly between priority

Does this change (=pulling down the priority of UV_BAU_VECTOR) not impact
users of the UV_BAU_MESSAGE?

I can see why REBOOT_VECTOR need to be highest priority.
Maybe you could pull down THERMAL_APIC_VECTOR/THRESHOLD_APIC_VECTOR
instead.  Why you choose UV_BAU_MESSAGE?


Thanks,
H.Seto

