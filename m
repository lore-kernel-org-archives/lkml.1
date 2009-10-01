Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbZJANgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbZJANgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 09:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZJANgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 09:36:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224AbZJANgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 09:36:10 -0400
Message-ID: <4AC4B020.9080107@redhat.com>
Date: Thu, 01 Oct 2009 09:35:28 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090806 Fedora/3.0-3.8.b3.fc12 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: ketuzsezr@darnok.org, Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Martin Wilck <Martin.Wilck@fujitsu-siemens.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iSCSI/iBFT: use proper address translation
References: <4AC47DED0200007800017743@vpn.id2.novell.com>
In-Reply-To: <4AC47DED0200007800017743@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 04:01 AM, Jan Beulich wrote:
> In virtual environments (namely, Xen Dom0) virt <-> phys and
> virt <-> isa-bus translations cannot be freely interchanged. When
> looking at memory below 1M, the latter translations should always
> be used.
> 
> iscsi_ibft_find.c part from: Martin Wilck <martin.wilck@ts.fujitsu.com>.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

Looks good to me.

Signed-off-by: Peter Jones <pjones@redhat.com>

> 
> ---
>  drivers/firmware/iscsi_ibft.c      |    2 +-
>  drivers/firmware/iscsi_ibft_find.c |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.32-rc1/drivers/firmware/iscsi_ibft.c	2009-06-10 05:05:27.000000000 +0200
> +++ 2.6.32-rc1-ibft-addr-xlat/drivers/firmware/iscsi_ibft.c	2009-09-24 12:14:48.000000000 +0200
> @@ -939,7 +939,7 @@ static int __init ibft_init(void)
>  
>  	if (ibft_addr) {
>  		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
> -		       (u64)virt_to_phys((void *)ibft_addr));
> +		       (u64)isa_virt_to_bus(ibft_addr));
>  
>  		rc = ibft_check_device();
>  		if (rc)
> --- linux-2.6.32-rc1/drivers/firmware/iscsi_ibft_find.c	2008-10-10 00:13:53.000000000 +0200
> +++ 2.6.32-rc1-ibft-addr-xlat/drivers/firmware/iscsi_ibft_find.c	2009-09-24 09:52:18.000000000 +0200
> @@ -65,10 +65,10 @@ void __init reserve_ibft_region(void)
>  		 * so skip that area */
>  		if (pos == VGA_MEM)
>  			pos += VGA_SIZE;
> -		virt = phys_to_virt(pos);
> +		virt = isa_bus_to_virt(pos);
>  		if (memcmp(virt, IBFT_SIGN, IBFT_SIGN_LEN) == 0) {
>  			unsigned long *addr =
> -			    (unsigned long *)phys_to_virt(pos + 4);
> +			    (unsigned long *)isa_bus_to_virt(pos + 4);
>  			len = *addr;
>  			/* if the length of the table extends past 1M,
>  			 * the table cannot be valid. */
> 
> 
> 


-- 
        Peter

When privacy is outlawed only outlaws will have privacy.
		-- Zimmermann
