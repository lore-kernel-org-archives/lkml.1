Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbYIRP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbYIRP0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYIRP0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:26:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbYIRP0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:26:11 -0400
Message-ID: <48D272F9.3090001@zytor.com>
Date: Thu, 18 Sep 2008 08:25:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com> <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu> <48D23BF6.76E4.0078.0@novell.com>
In-Reply-To: <48D23BF6.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> +
> +#ifdef CONFIG_X86_32
> +	if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
> +		c->x86_phys_bits = 36;
> +#endif
>  }
>  

I'm confused about this.

There is no reason for this to be #ifdef'd; but it should be conditional 
on this information not being otherwise available (which will always be 
the case on 64 bits), I would assume.  If we are setting a value there, 
we should presumably also set 32 in the other case.

	-hpa
