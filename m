Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZE0Ea7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZE0Ea7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbZE0Eaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:30:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44277 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015AbZE0Eap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:30:45 -0400
Message-ID: <4A1CC1EB.3030303@jp.fujitsu.com>
Date: Wed, 27 May 2009 13:30:35 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 06/31] x86: Fix panic with interrupts off (needed for
 MCE)
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com> <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com> <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com> <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com> <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com> <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
In-Reply-To: <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> @@ -89,11 +89,7 @@
>  
>  #define THRESHOLD_APIC_VECTOR		0xf9
>  
> -#ifdef CONFIG_X86_32
> -/* 0xf9 : free */
> -#else
> -# define UV_BAU_MESSAGE			0xf8
> -#endif
> +#define REBOOT_VECTOR			0xf8
>  
>  /* f0-f7 used for spreading out TLB flushes: */
>  #define INVALIDATE_TLB_VECTOR_END	0xf7
> @@ -117,6 +113,8 @@
>   */
>  #define GENERIC_INTERRUPT_VECTOR	0xed
>  
> +#define UV_BAU_MESSAGE			0xec
> +
>  /*
>   * First APIC vector available to drivers: (vectors 0x30-0xee) we
>   * start at 0x31(0x41) to spread out vectors evenly between priority

#ifdef CONFIG_X86_64
#define UV_BAU_MESSAGE			0xec
#endif

Isn't it?


Thanks,
H.Seto

