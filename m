Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZEMFro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZEMFro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZEMFrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:47:35 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59885 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZEMFre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:47:34 -0400
X-BigFish: VPS-25(z5edJz1432R98dR1805M936fJzz1202hzz5a6ciz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJKIQ9-01-7F9-01
Date: Wed, 13 May 2009 07:46:27 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 8/10 -tip] x86: Add cpufeature for Microcode update
Message-ID: <20090513054627.GB9991@alberich.amd.com>
References: <1242142530.2547.11.camel@ht.satnam> <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam> <1242142753.2547.16.camel@ht.satnam> <1242142807.2547.18.camel@ht.satnam> <1242142849.2547.19.camel@ht.satnam> <1242142908.2547.20.camel@ht.satnam> <1242142941.2547.21.camel@ht.satnam> <1242142996.2547.22.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1242142996.2547.22.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 May 2009 05:46:56.0655 (UTC) FILETIME=[39DFB9F0:01C9D38E]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 09:13:16PM +0530, Jaswinder Singh Rajput wrote:
> 
> Setting microcode update feature to friendly access of UCODE MSRs like:
> 1. IA32_PLATFORM_ID (Intel)
> 2. IA32_UCODE_WRITE (Intel)
> 3. IA32_UCODE_REV (Intel)
> 4. MSR_AMD64_PATCH_LEVEL (AMD)
> 5. MSR_AMD64_PATCH_LOADER (AMD)
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

NAK! There is absolutely no point in moving the CPU
family/model/revision checks from the microcode drivers into generic
setup code.

Please explain what's the benefit of this?

>  arch/x86/include/asm/cpufeature.h |    1 +
>  arch/x86/kernel/cpu/amd.c         |   12 ++++++++++++
>  arch/x86/kernel/cpu/intel.c       |   11 +++++++++++
>  3 files changed, 24 insertions(+), 0 deletions(-)

I just see that it adds additional lines of code without any benefit.
You don't even check for this flag in microcode_core code which would
have introduced a "minor use case" of this.

Instead of checking CPU family/model/revision in those drivers (that
are really requiring this information and really know what to check
for) you disperse the handling of it over the kernel.

Last not least. The check in the AMD microcode loader driver ensures
that only AMD CPU families >= 0x10 are handled by the driver. It's a
mystery to me how this information is useful to set a generic
microcode feature flag "to friendly access of UCODE MSRs".

Maybe you wanted to introduce a generic flag to indicate that certain
MSRs are available. Then this check is just bogus.

Please, if you want to access microcode related MSRs in other parts of
the kernel, introduce the right CPU family and revision checks at the new
respective places.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


