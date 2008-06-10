Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYFJWOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYFJWOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYFJWOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:14:32 -0400
Received: from mail.macqel.be ([194.78.208.39]:25730 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbYFJWOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:14:31 -0400
Date: Wed, 11 Jun 2008 00:14:27 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver/video/cirrusfb : Fix RAM address printk
Message-ID: <20080610221427.GA28607@frolo.macqel>
References: <20080610214255.GA27749@frolo.macqel> <484EF759.3030806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484EF759.3030806@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 11:51:21PM +0200, Jiri Slaby wrote:
> On 06/10/2008 11:42 PM, Philippe De Muyter wrote:
>> Hello everybody,
>> In the cirrusfb driver, the RAM address printk has a superfluous 'x'
>> that could be interpreted as "don't care", while it is actually a typo.
>> Fix that.
>> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>> diff -r 184e1bb486cf drivers/video/cirrusfb.c
>> --- a/drivers/video/cirrusfb.c	Mon Jun  9 19:30:13 2008 -0700
>> +++ b/drivers/video/cirrusfb.c	Tue Jun 10 13:25:22 2008 +0200
>> @@ -2432,7 +2432,7 @@ static int cirrusfb_pci_register(struct  
>> 	info->screen_size = board_size;
>>  	cinfo->unmap = cirrusfb_pci_unmap;
>>  -	printk(KERN_INFO " RAM (%lu kB) at 0xx%lx, ",
>> +	printk(KERN_INFO " RAM (%lu kB) at 0x%lx, ",
>>  		info->screen_size >> 10, board_addr);
>
> Hmm, is there \n missing too?
>

No that would make the RAM adress orphan, but we must also remove KERN_INFO
in the printk below.

>>  	printk(KERN_INFO "Cirrus Logic chipset on PCI bus\n");
>>  	pci_set_drvdata(pdev, info);
