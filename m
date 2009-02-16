Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZBPLeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZBPLeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 06:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZBPLeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 06:34:11 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:17850 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZBPLeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 06:34:10 -0500
X-BigFish: VPS-50(z21eWz1432R62a3L98dR936eQ1805Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KF5PGE-04-JLJ-01
Date: Mon, 16 Feb 2009 12:33:50 +0100
From: Robert Richter <robert.richter@amd.com>
To: Tim Blechmann <tim@klingt.org>
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc4 regression (was: Re: 2.6.28-rc9: oprofile
	regression)
Message-ID: <20090216113349.GF25042@erda.amd.com>
References: <1229869416.6911.1.camel@thinkpad> <49932C35.3020300@klingt.org> <20090213190740.GD25042@erda.amd.com> <20090216112313.359ef437@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090216112313.359ef437@thinkpad>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Feb 2009 11:33:50.0170 (UTC) FILETIME=[702B93A0:01C9902A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.02.09 11:23:13, Tim Blechmann wrote:
> > still, I can not reproduce this with my tests with v2.6.29-rc4. The
> > regression on the systems I have runs fine on rc4. On the system you
> > have, is commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8 the first bad
> > one? If so, I will split the patch into smaller pieces to find the
> > change that introduces the bug.
> 
> i got revision df13b31c286b3e91c556167954eda088d90a4295 working, by not
> resetting the counter width:
> 
> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> index 12e207a..f0e019d 100644
> --- a/arch/x86/oprofile/op_model_ppro.c
> +++ b/arch/x86/oprofile/op_model_ppro.c
> @@ -76,12 +76,14 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>  			return;
>  	}
>  
> +#if 0
>  	if (cpu_has_arch_perfmon) {
>  		union cpuid10_eax eax;
>  		eax.full = cpuid_eax(0xa);
>  		if (counter_width < eax.split.bit_width)
>  			counter_width = eax.split.bit_width;
>  	}
> +#endif
> 
> 
> this tweak did not work on later kernels, that i tested, though, and i 
> haven't had time to look into it in more detail.

Thanks Tim, on later kernels, is it the behaviour you mentioned that
no NMIs are delivered and you do not receive any NMI?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

