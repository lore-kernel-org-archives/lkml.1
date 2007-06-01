Return-Path: <linux-kernel-owner+w=401wt.eu-S932236AbXFASlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbXFASlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762004AbXFASlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:41:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35918 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761815AbXFASld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:41:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 2.6.21 1/3] x86_64: EFI64 support
References: <20070501185945.237601000@em64tdvp.jf.intel.com>
	<20070501190110.770881000@em64tdvp.jf.intel.com>
Date: Fri, 01 Jun 2007 12:39:33 -0600
In-Reply-To: <20070501190110.770881000@em64tdvp.jf.intel.com> (Chandramouli
	Narayanan's message of "Tue, 01 May 2007 11:59:46 -0700")
Message-ID: <m1fy5b1pui.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for the late replay I missed this patch series going by the first time.
> +static efi_status_t
> +phys_efi_set_virtual_address_map(unsigned long memory_map_size,
> +				 unsigned long descriptor_size,
> +				 u32 descriptor_version,
> +				 efi_memory_desc_t *virtual_map)
> +{
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog();
> +	status = efi_call_phys(efi_phys.set_virtual_address_map,
> +					EFI_ARG_NUM_SET_VIRTUAL_ADDRESS_MAP,
> +					(unsigned long)memory_map_size,
> +					(unsigned long)descriptor_size,
> +					(unsigned long)descriptor_version, 
> +					(unsigned long)virtual_map);
> +	efi_call_phys_epilog();
> +	return status;
> +}

Please, Please kill this.

As far as I can tell virtual mode is incompatible with kexec.
It is unnecessary because none of the EFI calls are fast path.

Further I believe that using virtual addresses is likely to
make things more brittle.

So please drop the EFI virtual mode nonsense.

Thank you,
Eric
