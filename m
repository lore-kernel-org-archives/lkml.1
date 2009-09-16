Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbZIPEme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbZIPEme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZIPEmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:42:32 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:31335 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbZIPEm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:42:26 -0400
X-SpamScore: 2
X-BigFish: VPS2(zz1432R98dNzz1202hzz3198u327alz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQ1RQJ-02-7IE-02
X-M-MSG: 
Date: Wed, 16 Sep 2009 06:41:51 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] edac: need to export cpu_llc_id
Message-ID: <20090916044151.GB5767@aftab>
References: <20090916093935.6bc2c91f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090916093935.6bc2c91f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Sep 2009 04:41:50.0691 (UTC) FILETIME=[01C96B30:01CA3688]
X-Bypass-Agent: EF-1;
X-Reverse-DNS: unknown
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Sep 16, 2009 at 09:39:35AM +1000, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> ERROR: "per_cpu__cpu_llc_id" [drivers/edac/edac_core.ko] undefined!
> 
> Caused by commit b69b29de65fe4078b125acc9dea34be82f7c362c ("EDAC, AMD:
> carve out MCi_STATUS decoding").
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/x86/kernel/smpboot.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index a25eeec..04c74b4 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -100,6 +100,7 @@ EXPORT_SYMBOL(smp_num_siblings);
>  
>  /* Last level cache ID of each logical CPU */
>  DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
> +EXPORT_PER_CPU_SYMBOL(cpu_llc_id);
>  
>  /* representing HT siblings of each logical CPU */
>  DEFINE_PER_CPU(cpumask_var_t, cpu_sibling_map);
> -- 
> 1.6.3.3

proper fix is at http://marc.info/?l=linux-kernel&m=125302459621925

we still have to figure out who's gonna pick it up. Ingo?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

