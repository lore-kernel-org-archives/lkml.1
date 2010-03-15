Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936267Ab0CONGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:06:36 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:44945 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934247Ab0CONGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=htQ+0mSUNowen2SPTNM0fl8hcE4CJR13eZChsM9vkJzrINFBze4FIa07m6z8Ogdp+H
         f/qJ9tnoPxKv/3SiPz8Ap1Yd5L5jue53yy7KzOdm6Z5q+njYb1QHT6KXRt2P1u6R4Mh+
         lc8HeKYj3lD+AGHxEuVzFgtva/6KB9hM0PQ+w=
Message-ID: <4B9E30D5.2030001@garzik.org>
Date: Mon, 15 Mar 2010 09:06:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [git patches] libata updates for 2.6.34
References: <20100301202330.GA14977@havoc.gtf.org>	 <alpine.LFD.2.00.1003091304400.3583@i5.linux-foundation.org>	 <4B96C7B2.3080008@garzik.org> <4B971F83.4030505@kernel.org>	 <4B9DA1BB.9010808@garzik.org> <40a4ed591003150033w5c416b28rfae989fa2ddf7305@mail.gmail.com>
In-Reply-To: <40a4ed591003150033w5c416b28rfae989fa2ddf7305@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 03:33 AM, Zeno Davatz wrote:
> On Mon, Mar 15, 2010 at 3:55 AM, Jeff Garzik<jeff@garzik.org>  wrote:
>> On 03/09/2010 11:26 PM, Tejun Heo wrote:
>>>
>>> Hello, Linus, Jeff.
>>>
>>> On 03/10/2010 07:12 AM, Jeff Garzik wrote:
>>>>
>>>> Coincedentally, it looks like someone else just reported the same
>>>> problem, with 2.6.34-rc1.
>>>>
>>>> It definitely sounds like a race.  READ DMA is a DMA command as the name
>>>> implies, so that eliminates the possibility of polling-related paths in
>>>> ata_sff_interrupt (libata-sff.c).
>>>>
>>>> I'll flip some of my machines to the icky slow boring piix mode, rather
>>>> than sexy AHCI mode :) to see if I can reproduce.  I have had a feeling
>>>> that we needed a more sophisticated IRQ handling setup, this may be what
>>>> was needed.  Lost interrupt recovery should occur faster than 30 seconds
>>>> in any case, and should not require a hard reset if the hardware
>>>> functions just fine outside of the lost-interrupt / race that just
>>>> occurred.
>>>
>>> Yeap, there is a race condition with clearing which I don't think we
>>> can solve completely but with some modification I think we can at
>>> least cover known failure cases.
>>>
>>> For longer term, I don't think we can solve this by diddling with the
>>> SFF registers.  The interface is just way too ancient and horrid to
>>> build anything reliable on top of.  I'm planning on implementing
>>> smarter IRQ storm handling and stepped timeouts for ATA commands.
>>
>> A tester on this bug
>>         http://bugzilla.kernel.org/show_bug.cgi?id=15537
>> seemed to find success with the patch.
>
> Thanks for the Update!
>
> I will wait some more and then test rc-2.

Can you test the patch, please?

	Jeff



