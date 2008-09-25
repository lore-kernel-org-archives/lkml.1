Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYIYRKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYIYRKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYIYRKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:10:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:23692 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYIYRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SWFWTiOXybUQ1qFsSWqPbf+1AKReRRBek/P2OgPb4ipGqJJ4mhKB/Gk6Mez+CtBMq2
         BcEh75psoM/GGlKbgCGb6jGxHCtGlbAB+RSWu57fUq7YhB+cmPcWyE4lgiqOMNgWhqnm
         6vb3Jy95wCN+ll2FNuoc7jZxHVNTyukV+3Mi8=
Message-ID: <86802c440809251010r77e0aea2pfdf2e16b6441fe32@mail.gmail.com>
Date: Thu, 25 Sep 2008 10:10:06 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 2/7] acpi: remove have_arch_parse_srat in acpi.h
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Len Brown" <lenb@kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <200809250901.09212.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
	 <1222308277-10984-2-git-send-email-yhlu.kernel@gmail.com>
	 <200809250901.09212.bjorn.helgaas@hp.com>
X-Google-Sender-Auth: 4591593cd402f838
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 8:01 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Wednesday 24 September 2008 08:04:32 pm Yinghai Lu wrote:
>> 32bit don't need that anymore
>
> I don't understand the connection between this commit log and
> the patch below.
>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> ---
>>  include/linux/acpi.h |    8 --------
>>  1 files changed, 0 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>> index 4d5ec43..8eefaa9 100644
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -95,18 +95,10 @@ int acpi_parse_mcfg (struct acpi_table_header *header);
>>  void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
>>
>>  /* the following four functions are architecture-dependent */
>> -#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
>> -#define NR_NODE_MEMBLKS MAX_NUMNODES
>> -#define acpi_numa_slit_init(slit) do {} while (0)
>> -#define acpi_numa_processor_affinity_init(pa) do {} while (0)
>> -#define acpi_numa_memory_affinity_init(ma) do {} while (0)
>> -#define acpi_numa_arch_fixup() do {} while (0)
>> -#else
>>  void acpi_numa_slit_init (struct acpi_table_slit *slit);
>>  void acpi_numa_processor_affinity_init (struct acpi_srat_cpu_affinity *pa);
>>  void acpi_numa_memory_affinity_init (struct acpi_srat_mem_affinity *ma);
>>  void acpi_numa_arch_fixup(void);
>> -#endif
>>
>>  #ifdef CONFIG_ACPI_HOTPLUG_CPU
>>  /* Arch dependent functions for cpu hotplug support */
>
there was some workaround for 32bit numa (srat processing),  and we
removed those workaround, and make 32bit more like 64bit.

now HAVE_ARCH_PARSE_SRAT is not defined in any place.

YH
