Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0CJU3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:29:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48277 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab0CJU3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:29:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH v3] intel_txt: add support for S3 memory integrity protection within Intel(R) TXT launched kernel
Date: Wed, 10 Mar 2010 21:31:46 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
References: <4A9CE0B2.5060608@intel.com> <D5AB6E638E5A3E4B8F4406B113A5A19A1D44A8FA@shsmsx501.ccr.corp.intel.com> <4B973DDA.6050902@intel.com>
In-Reply-To: <4B973DDA.6050902@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003102131.46743.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 March 2010, Shane Wang wrote:
> <compared with v2, this patch adds a check of array size in tboot.c, and a note 
> to specify which c/s of tboot supports this kind of MACing in intel_txt.txt>
> 
> v3: Based on a complexity analysis and tradeoff, we moved all MAC'ing into
> tboot.
> 
> This patch adds support for S3 memory integrity protection within an Intel(R)
> TXT launched kernel, for all kernel and userspace memory.  All RAM used by the
> kernel and userspace, as indicated by memory ranges of type E820_RAM and
> E820_RESERVED_KERN in the e820 table, will be integrity protected.
> 
> The MAINTAINERS file is also updated to reflect the maintainers of the
> TXT-related code.
> 
> Signed-off-by: Shane Wang <shane.wang@intel.com>
> Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

>   Documentation/intel_txt.txt |   16 +++++++++-------
>   MAINTAINERS                 |   11 +++++++++++
>   arch/x86/include/asm/e820.h |    7 ++++++-
>   arch/x86/kernel/tboot.c     |   20 +++++++++++---------
>   4 files changed, 37 insertions(+), 17 deletions(-)
> 
> diff -r d2911aa1461d Documentation/intel_txt.txt
> --- a/Documentation/intel_txt.txt	Thu Mar 04 09:37:53 2010 -0500
> +++ b/Documentation/intel_txt.txt	Wed Mar 10 08:18:48 2010 -0500
> @@ -161,13 +161,15 @@ o  In order to put a system into any of
>         has been restored, it will restore the TPM PCRs and then
>         transfer control back to the kernel's S3 resume vector.
>         In order to preserve system integrity across S3, the kernel
> -      provides tboot with a set of memory ranges (kernel
> -      code/data/bss, S3 resume code, and AP trampoline) that tboot
> -      will calculate a MAC (message authentication code) over and then
> -      seal with the TPM.  On resume and once the measured environment
> -      has been re-established, tboot will re-calculate the MAC and
> -      verify it against the sealed value.  Tboot's policy determines
> -      what happens if the verification fails.
> +      provides tboot with a set of memory ranges (RAM and RESERVED_KERN
> +      in the e820 table, but not any memory that BIOS might alter over
> +      the S3 transition) that tboot will calculate a MAC (message
> +      authentication code) over and then seal with the TPM. On resume
> +      and once the measured environment has been re-established, tboot
> +      will re-calculate the MAC and verify it against the sealed value.
> +      Tboot's policy determines what happens if the verification fails.
> +      Note that the c/s 194 of tboot which has the new MAC code supports
> +      this.
> 
>   That's pretty much it for TXT support.
> 
> diff -r d2911aa1461d MAINTAINERS
> --- a/MAINTAINERS	Thu Mar 04 09:37:53 2010 -0500
> +++ b/MAINTAINERS	Wed Mar 10 08:18:48 2010 -0500
> @@ -2891,6 +2891,17 @@ F:	Documentation/networking/README.ipw22
>   F:	Documentation/networking/README.ipw2200
>   F:	drivers/net/wireless/ipw2x00/ipw2200.*
> 
> +INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)
> +M:	Joseph Cihula <joseph.cihula@intel.com>
> +M:	Shane Wang <shane.wang@intel.com>
> +L:	tboot-devel@lists.sourceforge.net
> +W:	http://tboot.sourceforge.net
> +T:	Mercurial http://www.bughost.org/repos.hg/tboot.hg
> +S:	Supported
> +F:	Documentation/intel_txt.txt
> +F:	include/linux/tboot.h
> +F:	arch/x86/kernel/tboot.c
> +
>   INTEL WIRELESS WIMAX CONNECTION 2400
>   M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
>   M:	linux-wimax@intel.com
> diff -r d2911aa1461d arch/x86/include/asm/e820.h
> --- a/arch/x86/include/asm/e820.h	Thu Mar 04 09:37:53 2010 -0500
> +++ b/arch/x86/include/asm/e820.h	Wed Mar 10 08:18:48 2010 -0500
> @@ -45,7 +45,12 @@
>   #define E820_NVS	4
>   #define E820_UNUSABLE	5
> 
> -/* reserved RAM used by kernel itself */
> +/*
> + * reserved RAM used by kernel itself
> + * if CONFIG_INTEL_TXT is enabled, memory of this type will be
> + * included in the S3 integrity calculation and so should not include
> + * any memory that BIOS might alter over the S3 transition
> + */
>   #define E820_RESERVED_KERN        128
> 
>   #ifndef __ASSEMBLY__
> diff -r d2911aa1461d arch/x86/kernel/tboot.c
> --- a/arch/x86/kernel/tboot.c	Thu Mar 04 09:37:53 2010 -0500
> +++ b/arch/x86/kernel/tboot.c	Wed Mar 10 08:18:48 2010 -0500
> @@ -130,6 +130,9 @@ static void add_mac_region(phys_addr_t s
>   	struct tboot_mac_region *mr;
>   	phys_addr_t end = start + size;
> 
> +	if (tboot->num_mac_regions >= MAX_TB_MAC_REGIONS)
> +		panic("tboot: Too many MAC regions\n");
> +
>   	if (start && size) {
>   		mr = &tboot->mac_regions[tboot->num_mac_regions++];
>   		mr->start = round_down(start, PAGE_SIZE);
> @@ -139,18 +142,17 @@ static void add_mac_region(phys_addr_t s
> 
>   static void __init tboot_setup_sleep(void)
>   {
> +	int i;
> +
>   	tboot->num_mac_regions = 0;
> 
> -	/* S3 resume code */
> -	add_mac_region(acpi_wakeup_address, WAKEUP_SIZE);
> +	for (i = 0; i < e820.nr_map; i++) {
> +		if ((e820.map[i].type != E820_RAM)
> +		 && (e820.map[i].type != E820_RESERVED_KERN))
> +			continue;
> 
> -#ifdef CONFIG_X86_TRAMPOLINE
> -	/* AP trampoline code */
> -	add_mac_region(virt_to_phys(trampoline_base), TRAMPOLINE_SIZE);
> -#endif
> -
> -	/* kernel code + data + bss */
> -	add_mac_region(virt_to_phys(_text), _end - _text);
> +		add_mac_region(e820.map[i].addr, e820.map[i].size);
> +	}
> 
>   	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
>   }
> 
> 

