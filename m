Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489AbZGJGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbZGJGtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbZGJGtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:49:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39478 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZGJGtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:49:09 -0400
Date: Fri, 10 Jul 2009 08:48:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 04/12] SFI: create include/linux/sfi.h
Message-ID: <20090710064845.GG22218@elte.hu>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com> <56f1291c60859b65ac62521e7fe4b82e73205ef6.1247025117.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56f1291c60859b65ac62521e7fe4b82e73205ef6.1247025117.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> include/linux/include/sfi.h defines everything that customers
> of SFI need to know in order to use the SFI suport in the kernel.
> 
> The primary API is sfi_table_parse(), where a driver or another part
> of the kernel can supply a handler to parse the named table.
> 
> sfi.h also includes the currently defined table signatures and table formats.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  include/linux/sfi.h |  198 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 198 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/sfi.h
> 
> diff --git a/include/linux/sfi.h b/include/linux/sfi.h
> new file mode 100644
> index 0000000..f00f4da
> --- /dev/null
> +++ b/include/linux/sfi.h
> @@ -0,0 +1,198 @@
> +/* sfi.h Simple Firmware Interface */
> +
> +/*
> + * Copyright (C) 2009, Intel Corp.
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions, and the following disclaimer,
> + *    without modification.
> + * 2. Redistributions in binary form must reproduce at minimum a disclaimer
> + *    substantially similar to the "NO WARRANTY" disclaimer below
> + *    ("Disclaimer") and any redistribution must be conditioned upon
> + *    including a substantially similar Disclaimer requirement for further
> + *    binary redistribution.
> + * 3. Neither the names of the above-listed copyright holders nor the names
> + *    of any contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.
> + *
> + * Alternatively, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") version 2 as published by the Free
> + * Software Foundation.
> + *
> + * NO WARRANTY
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
> + * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> + * POSSIBILITY OF SUCH DAMAGES.
> + */
> +
> +#ifndef _LINUX_SFI_H
> +#define _LINUX_SFI_H
> +
> +/* Table signatures reserved by the SFI specification */
> +#define SFI_SIG_SYST		"SYST"
> +#define SFI_SIG_FREQ		"FREQ"
> +#define SFI_SIG_IDLE		"IDLE"
> +#define SFI_SIG_CPUS		"CPUS"
> +#define SFI_SIG_MTMR		"MTMR"
> +#define SFI_SIG_MRTC		"MRTC"
> +#define SFI_SIG_MMAP		"MMAP"
> +#define SFI_SIG_APIC		"APIC"
> +#define SFI_SIG_XSDT		"XSDT"
> +#define SFI_SIG_WAKE		"WAKE"
> +#define SFI_SIG_SPIB		"SPIB"
> +#define SFI_SIG_I2CB		"I2CB"
> +#define SFI_SIG_GPEM		"GPEM"

Sidenote: these strings, if used in different places, might be 
instantiated in a duplicated way, bloating the kernel a tiny bit. It 
might be better to do an intermediate const array and return 
elements of them.

> +
> +#define SFI_ACPI_TABLE		(1 << 0)
> +#define SFI_NORMAL_TABLE	(1 << 1)
> +
> +#define SFI_SIGNATURE_SIZE	4
> +#define SFI_OEM_ID_SIZE		6
> +#define SFI_OEM_TABLE_ID_SIZE	8
> +
> +#define SFI_SYST_SEARCH_BEGIN		0x000E0000
> +#define SFI_SYST_SEARCH_END		0x000FFFFF

(see my suggestion about the proper type of these in my other mail)

> +
> +#define SFI_GET_NUM_ENTRIES(ptable, entry_type) \
> +	((ptable->header.length - sizeof(struct sfi_table_header)) / \
> +	(sizeof(entry_type)))
> +/*
> + * Table structures must be byte-packed to match the SFI specification,
> + * as they are provided by the BIOS.
> + */
> +struct sfi_table_header {
> +	char	signature[SFI_SIGNATURE_SIZE];
> +	u32	length;
> +	u8	revision;
> +	u8	checksum;

These could be abbreviated with common terms:

 s/signature/sig
 s/length/len
 s/revision/rev
 s/checksum/csum

> +	char	oem_id[SFI_OEM_ID_SIZE];
> +	char	oem_table_id[SFI_OEM_TABLE_ID_SIZE];
> +} __packed;
> +
> +struct sfi_table_simple {
> +	struct sfi_table_header		header;
> +	u64				pentry[1];
> +} __packed;
> +
> +/* comply with UEFI spec 2.1 */
> +struct sfi_mem_entry {
> +	u32	type;
> +	u64	phy_start;

s/phy_start/phys_start

> +	u64	vir_start;

s/vir_start/virt_start

> +	u64	pages;
> +	u64	attrib;
> +} __packed;
> +
> +struct sfi_cpu_table_entry {
> +	u32	apicid;

s/apicid/apic_id

(i realize that apicid is still the commonly used one in arch/x86, 
but that's not a reason to continue that bad practice with new 
code.)

> +} __packed;
> +
> +struct sfi_cstate_table_entry {
> +	u32	hint;		/* MWAIT hint */
> +	u32	latency;	/* latency in ms */
> +} __packed;
> +
> +struct sfi_apic_table_entry {
> +	u64	phy_addr;	/* phy base addr for APIC reg */

s/phy_addr/phys_addr

> +} __packed;
> +
> +struct sfi_freq_table_entry {
> +	u32	freq;

is this in Hz or in kHz? (should be reflected in the name: say 
freq_khz)

I suspect it's HZ here - but that's not unambiguous - often cpufreq 
settings are in khz.

> +	u32	latency;	/* transition latency in ms */
> +	u32	ctrl_val;	/* value to write to PERF_CTL */

PERF_CTL is an u64 MSR.

> +} __packed;
> +
> +struct sfi_wake_table_entry {
> +	u64 phy_addr;	/* pointer to where the wake vector locates */

s/phy_addr/phys_addr

> +} __packed;
> +
> +struct sfi_timer_table_entry {
> +	u64	phy_addr;	/* phy base addr for the timer */

s/phy_addr/phys_addr

> +	u32	freq;		/* in HZ */

So we limit frequency to ~4 GHz?

> +	u32	irq;
> +} __packed;
> +
> +struct sfi_rtc_table_entry {
> +	u64	phy_addr;	/* phy base addr for the RTC */

s/phy_addr/phys_addr

> +	u32	irq;
> +} __packed;
> +
> +struct sfi_spi_table_entry {
> +	u16	host_num;	/* attached to host 0, 1...*/
> +	u16	cs;		/* chip select */
> +	u16	irq_info;
> +	char	name[16];
> +	u8	dev_info[10];
> +} __packed;
> +
> +struct sfi_i2c_table_entry {
> +	u16	host_num;
> +	u16	addr;		/* slave addr */
> +	u16	irq_info;
> +	char	name[16];
> +	u8	dev_info[10];
> +} __packed;
> +
> +struct sfi_gpe_table_entry {
> +	u16	logical_id;	/* logical id */
> +	u16	phy_id;		/* physical GPE id */

s/phy_id/phys_id

> +} __packed;
> +
> +
> +typedef int (*sfi_table_handler) (struct sfi_table_header *table);
> +
> +#ifdef	CONFIG_SFI

(stray tab.)

> +extern int __init sfi_init_memory_map(void);
> +extern void __init sfi_init(void);
> +extern int __init sfi_platform_init(void);
> +extern void __init sfi_init_late(void);
> +
> +int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
> +			uint flag, sfi_table_handler handler);

some prototypes come with externs ... some without. Please use one 
variant.

> +
> +extern int sfi_disabled;
> +static inline void disable_sfi(void)
> +{
> +	sfi_disabled = 1;
> +}
> +
> +#else /* !CONFIG_SFI */
> +
> +static inline int sfi_init_memory_map(void)
> +{
> +	return -1;
> +}
> +
> +static inline void sfi_init(void)
> +{
> +	return;
> +}

no need for that return.

Thanks,

	Ingo
