Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbYFJWZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbYFJWZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYFJWZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:25:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:4721 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYFJWZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SvZqQyQhDkob50YeNvGKNtwdzv9O4UYZ48NUfCmLHXnsRol8Ll7GD9TCCUcm9sdmOn
         XC+jrJD+ovo7Cb8eChOBZ7T6PgKcuMM0rKtw4+c0eVhxa2w52jZJemAmVLVB6S+aAuu+
         I7LuX9aK13VthSfoSDvVTHdyKalB0kRdoPpHg=
Message-ID: <484EFD1A.5040307@gmail.com>
Date: Wed, 11 Jun 2008 00:15:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver/video/cirrusfb : Fix RAM address printk
References: <20080610214255.GA27749@frolo.macqel> <484EF759.3030806@gmail.com> <20080610221427.GA28607@frolo.macqel>
In-Reply-To: <20080610221427.GA28607@frolo.macqel>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2008 12:14 AM, Philippe De Muyter wrote:
> On Tue, Jun 10, 2008 at 11:51:21PM +0200, Jiri Slaby wrote:
>> On 06/10/2008 11:42 PM, Philippe De Muyter wrote:
>>> Hello everybody,
>>> In the cirrusfb driver, the RAM address printk has a superfluous 'x'
>>> that could be interpreted as "don't care", while it is actually a typo.
>>> Fix that.
>>> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>>> diff -r 184e1bb486cf drivers/video/cirrusfb.c
>>> --- a/drivers/video/cirrusfb.c	Mon Jun  9 19:30:13 2008 -0700
>>> +++ b/drivers/video/cirrusfb.c	Tue Jun 10 13:25:22 2008 +0200
>>> @@ -2432,7 +2432,7 @@ static int cirrusfb_pci_register(struct  
>>> 	info->screen_size = board_size;
>>>  	cinfo->unmap = cirrusfb_pci_unmap;
>>>  -	printk(KERN_INFO " RAM (%lu kB) at 0xx%lx, ",
>>> +	printk(KERN_INFO " RAM (%lu kB) at 0x%lx, ",
>>>  		info->screen_size >> 10, board_addr);
>> Hmm, is there \n missing too?
>>
> 
> No that would make the RAM adress orphan, but we must also remove KERN_INFO
> in the printk below.

No please. This makes logs non-atomic. Make one printk from the two.

>>>  	printk(KERN_INFO "Cirrus Logic chipset on PCI bus\n");
>>>  	pci_set_drvdata(pdev, info);
