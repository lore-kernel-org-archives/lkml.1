Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYA3IHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYA3IHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYA3IHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:07:05 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:47320 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYA3IHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:07:04 -0500
Message-ID: <47A02EEE.9030508@linux.vnet.ibm.com>
Date: Wed, 30 Jan 2008 13:31:50 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       romieu@fr.zoreil.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD FAILURE]2.6.24-git6 build failure on sis190 ethernet driver
References: <479FF1F0.10907@linux.vnet.ibm.com> <47A00057.9090306@googlemail.com>
In-Reply-To: <47A00057.9090306@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Kamalesh Babulal wrote:
>> Hi,
>>
>> The 2.6.24-git6 kernel build fails on various x86_64 machines with the build failure
>>
>> drivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type conflict
>> make[2]: *** [drivers/net/sis190.o] Error 1
>>
>> # gcc --version (machine1)
>> gcc (GCC) 4.1.1 20070105 (Red Hat 4.1.1-52)
>>
>> # gcc --version (machine2)
>> gcc (GCC) 4.1.1 20060525 (Red Hat 4.1.1-1)
>>
> 
> Heh :) vger.kernel.org does not like emails directly from gmail , it seems =)
> 
> ( sorry for sending this 3 time now )
> 
> The following patch should fix the build failure.
> 
> diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
> index b570402..e48e4ad 100644
> --- a/drivers/net/sis190.c
> +++ b/drivers/net/sis190.c
> @@ -326,7 +326,7 @@ static const struct {
>  	{ "SiS 191 PCI Gigabit Ethernet adapter" },
>  };
> 
> -static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
> +static const struct pci_device_id sis190_pci_tbl[] __devinitdata = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
>  	{ 0, },
> 
> 
> Gabriel

Hi Gabriel,

Thanks, the patch fixes the build failure.


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
