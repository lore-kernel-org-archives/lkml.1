Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZCKC3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZCKC3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZCKC3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:29:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:64155 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbZCKC3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:29:09 -0400
Message-ID: <49B71EB7.8090205@windriver.com>
Date: Wed, 11 Mar 2009 10:15:19 +0800
From: Harry Ciao <qingtao.cao@windriver.com>
Reply-To: qingtao.cao@windriver.com
Organization: Wind River, CDC
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: Re: [v1 PATCH 3/8] EDAC: AMD8111 driver source file
References: <1236586097-3830-1-git-send-email-qingtao.cao@windriver.com>	<1236586097-3830-2-git-send-email-qingtao.cao@windriver.com>	<1236586097-3830-3-git-send-email-qingtao.cao@windriver.com>	<1236586097-3830-4-git-send-email-qingtao.cao@windriver.com> <20090310134607.1915c53c.akpm@linux-foundation.org>
In-Reply-To: <20090310134607.1915c53c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Mar 2009 02:27:49.0037 (UTC) FILETIME=[F883A5D0:01C9A1F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton 写道:
> On Mon,  9 Mar 2009 16:08:12 +0800
> Harry Ciao <qingtao.cao@windriver.com> wrote:
>
>   
>> Introduce AMD8111 EDAC driver source file, which makes use of error
>> detections on the LPC Bridge Controller and PCI Bridge Controller on
>> the AMD8111 HyperTransport I/O Hub.
>>
>>
>> ...
>>
>> +/* Wrapper functions for accessing PCI configuration space */
>> +static int edac_pci_read_dword(struct pci_dev *dev, int reg, u32 *val32)
>> +{
>> +	int ret;
>> +
>> +	ret = pci_read_config_dword(dev, reg, val32);
>> +	if (ret > 0)
>> +		printk(KERN_ERR AMD8111_EDAC_MOD_STR
>> +			" PCI Access Read Error at 0x%x\n", reg);
>> +
>> +	return ret;
>> +}
>>
>> +static void edac_pci_read_byte(struct pci_dev *dev, int reg, u8 *val8)
>> +{
>> +	int ret;
>> +
>> +	ret = pci_read_config_byte(dev, reg, val8);
>> +	if (ret > 0)
>> +		printk(KERN_ERR AMD8111_EDAC_MOD_STR
>> +			" PCI Access Read Error at 0x%x\n", reg);
>> +}
>> +
>> +static void edac_pci_write_dword(struct pci_dev *dev, int reg, u32 val32)
>> +{
>> +	int ret;
>> +
>> +	ret = pci_write_config_dword(dev, reg, val32);
>> +	if (ret > 0)
>> +		printk(KERN_ERR AMD8111_EDAC_MOD_STR
>> +			" PCI Access Write Error at 0x%x\n", reg);
>> +}
>> +
>> +static void edac_pci_write_byte(struct pci_dev *dev, int reg, u8 val8)
>> +{
>> +	int ret;
>> +
>> +	ret = pci_write_config_byte(dev, reg, val8);
>> +	if (ret > 0)
>> +		printk(KERN_ERR AMD8111_EDAC_MOD_STR
>> +			" PCI Access Write Error at 0x%x\n", reg);
>> +}
>>     
>
>
> <spends a while trying to work out what the return value of
> pci_read_config_dword() means>
>
> <gets frustrated and gives up>
>
> Is it correct that all of these functions treat a +ve return value as
> an error?
>
>   
Hi Andrew,

I should have compared the ret with zero, anything other than zero would 
be treated as an error code. My mistake is resulted from the fact that 
for the time being the return value of these wrappers have not been used 
yet, they are used nothing but to print some error messages.

I will correct this in the v2 series of patches.

Best regards,

Harry


>> ...
>>
>>     
>
>   

