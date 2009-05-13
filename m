Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbZEMRIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbZEMRIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 13:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbZEMRIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 13:08:23 -0400
Received: from gw.goop.org ([64.81.55.164]:52164 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758358AbZEMRIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 13:08:23 -0400
Message-ID: <4A0AFE84.2040805@goop.org>
Date: Wed, 13 May 2009 10:08:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/10] x86/PCI: Enable scanning of all pci functions
References: <1242164891-3859-1-git-send-email-jeremy@goop.org>	<1242164891-3859-7-git-send-email-jeremy@goop.org> <20090513095535.140134e1@jbarnes-g45>
In-Reply-To: <20090513095535.140134e1@jbarnes-g45>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Tue, 12 May 2009 14:48:07 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> From: Alex Nixon <alex.nixon@citrix.com>
>>
>> Xen may want to enable scanning of all pci functions - if for example
>> the device at function 0 is not passed through to the guest, but the
>> device at function 1 is.
>>
>> [Impact: allow passthrough of just some PCI functions.]
>> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
>> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
>> ---
>>  arch/x86/include/asm/pci.h |    8 +++++++-
>>  arch/x86/pci/common.c      |    1 +
>>  2 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
>> index b51a1e8..092706e 100644
>> --- a/arch/x86/include/asm/pci.h
>> +++ b/arch/x86/include/asm/pci.h
>> @@ -21,6 +21,7 @@ struct pci_sysdata {
>>  extern int pci_routeirq;
>>  extern int noioapicquirk;
>>  extern int noioapicreroute;
>> +extern int pci_scan_all_fns;
>>  
>>  /* scan a bus after allocating a pci_sysdata for it */
>>  extern struct pci_bus *pci_scan_bus_on_node(int busno, struct
>> pci_ops *ops, @@ -48,7 +49,11 @@ extern unsigned int
>> pcibios_assign_all_busses(void); #else
>>  #define pcibios_assign_all_busses()	0
>>  #endif
>> -#define pcibios_scan_all_fns(a, b)	0
>> +
>> +static inline int pcibios_scan_all_fns(struct pci_bus *bus, int
>> devfn) +{
>> +	return pci_scan_all_fns;
>> +}
>>  
>>  extern unsigned long pci_mem_start;
>>  #define PCIBIOS_MIN_IO		0x1000
>> @@ -130,6 +135,7 @@ extern void pci_iommu_alloc(void);
>>  
>>  /* generic pci stuff */
>>  #include <asm-generic/pci.h>
>> +#undef pcibios_scan_all_fns
>>     
>
> This is a little gross... But then I don't see any places where it's
> actually defined to something true either.

I've got some code to set it in a series I haven't posted yet.

>   Maybe it should be a weak
> function or a new HAVE_FOO define instead.
>   

I'd probably go the weak function path if I were to do either of those, 
but do you think it would be significantly better?

    J

