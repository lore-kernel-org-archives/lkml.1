Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbXGaOpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbXGaOpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758240AbXGaOoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:44:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:45640 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbXGaOoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:44:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fQvfsQNQSizJBgcIgiwtjaSBhSD2zNQYVpUcuWjNebO5EsTmN3mZmqAoVsee+tznqJduOM1EAJsPQWSxDwCOborqp1xPVewqGuPZqA1rkzVyFJHI8cW4yDmNVhhpWAJFB1HFnCzaSs6BEBHrf38IVzzc3ro3K+7gq4woK2ztn8E=
Date: Tue, 31 Jul 2007 22:46:19 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci subsystem.
Message-ID: <20070731144619.GA8183@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125443.880871000@hawkeye.stone.uk.eu.org> <200707311553.29090.borntraeger@de.ibm.com> <alpine.LFD.0.999.0707311956170.26032@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707311956170.26032@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 08:00:12PM +0530, Satyam Sharma wrote:
>
>
>On Tue, 31 Jul 2007, Christian Borntraeger wrote:
>
>> Am Dienstag, 31. Juli 2007 schrieb jack@hawkeye.stone.uk.eu.org:
>> > --- a/drivers/pci/rom.c
>> > +++ b/drivers/pci/rom.c
>> > @@ -185,7 +185,7 @@ void __iomem *pci_map_rom_copy(struct pc
>> >  			  IORESOURCE_ROM_BIOS_COPY))
>> >  		return rom;
>> > 
>> > -	res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
>> > +	res->start = kmalloc(*size, GFP_KERNEL);
>> 
>> This looks wrong.
>
>Yup, a warning at the very least.
>
>> void * doesnt need a cast to a pointer, but res->start is an 
>> integer u32 type,
>
>It better not be, else we have a bug already anyway. Pointers are 64-bit
>on 64-bit archs. [ it turns out res->start is resource_size_t which is
>set properly as per CONFIG_RESOURCES_64BIT which itself is set properly
>as per CONFIG_64BIT, so everything is healthy and fine :-) ]
>

I agree.

However, I think using resource_size_t is a bit better than unsigned long,
so that we don't need to check the defination of it.

- res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
+ res->start = (resource_size_t)kmalloc(*size, GFP_KERNEL);

Is this change OK?

-- 
To do great work, you have to have a pure mind. You can think only about the
mathematics. Everything else is human weakness. Accepting prizes is showing
weakness.

