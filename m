Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbZAQOP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbZAQOP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 09:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbZAQOPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 09:15:10 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:51797 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbZAQOPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 09:15:08 -0500
X-BigFish: VPS-31(z21eWz1432R62a3L98dR936eQ1805M9320imzzzzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KDMCWS-01-NOH-01
Date: Sat, 17 Jan 2009 15:14:53 +0100
From: Robert Richter <robert.richter@amd.com>
To: Tim Blechmann <tim@klingt.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: 2.6.28-rc9: oprofile regression
Message-ID: <20090117141453.GA21604@erda.amd.com>
References: <49544497.9020900@linux.intel.com> <1230894257.6072.10.camel@thinkpad> <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain> <1231957184.13033.70.camel@thinkpad> <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain> <1232010853.6541.4.camel@thinkpad> <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain> <1232067181.6134.74.camel@thinkpad> <alpine.LFD.2.00.0901160956170.3400@localhost.localdomain> <1232199169.7016.12.camel@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1232199169.7016.12.camel@thinkpad>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2009 14:14:53.0901 (UTC) FILETIME=[F7CF67D0:01C978AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.01.09 14:32:49, Tim Blechmann wrote:
> hm, it seems a bit more complicated than i originally thought.
> 
> trying to reconstruct commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8, i
> found, that resetting counter_width in ppro_setup_ctrs, causes the
> issue. reverting part of the patch, resolved the issue:
> 
> --- a/arch/x86/oprofile/op_model_ppro.c
> +++ b/arch/x86/oprofile/op_model_ppro.c
> @@ -79,8 +79,8 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>         if (cpu_has_arch_perfmon) {
>                 union cpuid10_eax eax;
>                 eax.full = cpuid_eax(0xa);
> -               if (counter_width < eax.split.bit_width)
> -                       counter_width = eax.split.bit_width;
> +//             if (counter_width < eax.split.bit_width)
> +//                     counter_width = eax.split.bit_width;
>         }
>  
>         /* clear all counters */
> 
> 
> however, trying to apply this patch to 2.6.28, the behavior is the same
> as before (one NMI) ... so possibly, it is a combination of two bugs,
> with similar symptoms ... 

Tim, could you revert 7c64ade53a6f977d73f16243865c42ceae999aea too?

If this not helps, last chance is
59512900baab03c5629f2ff5efad1d5d4e682ece, but this seems to be save.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

