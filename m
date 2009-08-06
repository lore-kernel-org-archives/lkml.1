Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZHFXMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZHFXMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:12:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbZHFXMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:12:02 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:44903 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848AbZHFXMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:12:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CRDhgKPN2EXNss7aw6shSetPxdVNTLgQA0zmCtI5f1sawjc/f1KdTjenIBEWlMe7Y1
         8pm8fskQVx9Qh4fLpOWhjoWVm1T+9S/O2DIx8Tfmo++QtQlYAyaIa69MR+rgLqVkodeO
         ElUc5MjQa3IvcyhRlarNt5537tL1JHBo9cn4I=
Message-ID: <4A7B633C.3040500@gmail.com>
Date: Thu, 06 Aug 2009 17:11:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chetan.Loke@Emulex.Com
CC: tony@linx.net, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, philipl@overt.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for sata_nv
References: <20090805192055.8F2DE1007C@gold.linx.net>	 <4A7A16C9.6030500@gmail.com>	 <412A05BA40734D4887DBC67661F433080D73228B@EXMAIL.ad.emulex.com> <1249574363.4530.23.camel@localhost> <412A05BA40734D4887DBC67661F433080D7322B1@EXMAIL.ad.emulex.com>
In-Reply-To: <412A05BA40734D4887DBC67661F433080D7322B1@EXMAIL.ad.emulex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2009 10:28 AM, Chetan.Loke@Emulex.Com wrote:
>> -----Original Message-----
>> From: Tony Vroon [mailto:tony@linx.net]
>> Sent: Thursday, August 06, 2009 11:59 AM
>> To: Loke,Chetan
>> Cc: hancockrwd@gmail.com; jgarzik@pobox.com; linux-ide@vger.kernel.org;
>> linux-kernel@vger.kernel.org; philipl@overt.org
>> Subject: RE: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for
>> sata_nv
>>
>>> disable_msi() is missing right?
>> I didn't add that as none of the other drivers have it:
>
> Then they would leak the MSI-vectors if request_irq fails.
>
>
>> chainsaw@amalthea /cvs/linux-2.6/drivers/ata $ grep _msi * | grep pci
>> ahci.c:		pci_enable_msi(pdev);
>> sata_mv.c:	if (msi&&  pci_enable_msi(pdev) == 0)
>> sata_vsc.c:	if (pci_enable_msi(pdev) == 0)
>>
>> (This is a tree without the sata_nv change I submitted)
>>
>> I do believe it is safe to shut the interrupt down and unload the
>> handler whilst it is still in MSI mode. At least, I don't see the libata
>> core special-casing it in any way.
>
> If I'm not wrong then that's how it's supposed to be done. free_irq and then disable_msi. You can't reverse the order. Also the driver should know when to quiesce the ASIC. So quiesce first and then shutdown everything.

Seems like devres should handle this somehow, or else something in 
libata core.. Tejun?
