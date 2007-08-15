Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbXHOEfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbXHOEfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 00:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXHOEfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 00:35:09 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:64728 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbXHOEfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 00:35:07 -0400
Date: Wed, 15 Aug 2007 00:35:01 -0400
To: <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 1 of 5 ] /drivers/char ioremap balancing/ returncode check
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070815043503.535662281F@mailserver9.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 16:17:29 -0400 Jiri Slaby <jirislaby@gmail.com> 
wrote:
>> diff --git a/drivers/char/sx.c b/drivers/char/sx.c
>> index 85a2328..30829ed 100644
>> --- a/drivers/char/sx.c
>> +++ b/drivers/char/sx.c
>> @@ -2627,6 +2627,12 @@ static void __devinit fix_sx_pci(struct 
>> pci_dev *pdev, struct sx_board *board)
>>  	pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0, &hwbase);
>>  	hwbase &= PCI_BASE_ADDRESS_MEM_MASK;
>>  	rebase = ioremap(hwbase, 0x80);
>> +	if (!rebase) {
>> +		printk(KERN_DEBUG 
>> +			"sx:ioremap fail, unable to perform cntrl reg fix\n");
>> +		return;
>> +	}
>> +		
>
>1) this should be pci_iomap(pdev, 0, 0x80)
The ioremap call was there before my patch and I'm just trying to 
audit ioremap calls to make sure that they are cleaned up and have 
their return codes checked.   If you want me to take care of that 
"while I'm in the neighborhood", let me know, but trying to avoid 
too much scope creep on my audit to increase chances it actually 
gets included...

>2) KERN_DEBUG is inappropriate and wrap the string in the middle 
>and not in the
>beginning

Agree on the wordwrap, several artifacts were created on this 
patchset and this whole thing will be resubmitted through a 
different mail client. 
As for KERN_DEBUG, KERN_DEBUG is used in the function following 
this call as notification that this workaround was required.  When 
I audit code as I am here I generally try to blend the patch in 
with the style and conventions of the code around it.  If 
KERN_DEBUG is inappropriate on the subsequent call, both values 
should be changed.  

Let me know your preferences on these issues and I will include in 
the next pass.  Thanks for your comments and review...

---------------------------------------
Scott Thompson / postfail@hushmail.com
---------------------------------------

