Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0COHdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:33:11 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:59311 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0COHdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gWUA+tUrll5VH6BqGGHoe04g9Ll5xeSyAmmCgS/nzuqh863VCz6EA/DezSyatVtLlv
         a3ZaJJHJDG9n/C96Gz73046+R7EWdFA1ZYKmMdDqP/ENN4cRtkYrKrnYXZfz3NqTe7qJ
         s7hIjcV2WwSAar3xfHqdrv0nvctQ710ZidVV4=
MIME-Version: 1.0
In-Reply-To: <4B9DA1BB.9010808@garzik.org>
References: <20100301202330.GA14977@havoc.gtf.org>
	 <alpine.LFD.2.00.1003091304400.3583@i5.linux-foundation.org>
	 <4B96C7B2.3080008@garzik.org> <4B971F83.4030505@kernel.org>
	 <4B9DA1BB.9010808@garzik.org>
Date: Mon, 15 Mar 2010 08:33:05 +0100
Message-ID: <40a4ed591003150033w5c416b28rfae989fa2ddf7305@mail.gmail.com>
Subject: Re: [git patches] libata updates for 2.6.34
From: Zeno Davatz <zdavatz@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 3:55 AM, Jeff Garzik <jeff@garzik.org> wrote:
> On 03/09/2010 11:26 PM, Tejun Heo wrote:
>>
>> Hello, Linus, Jeff.
>>
>> On 03/10/2010 07:12 AM, Jeff Garzik wrote:
>>>
>>> Coincedentally, it looks like someone else just reported the same
>>> problem, with 2.6.34-rc1.
>>>
>>> It definitely sounds like a race.  READ DMA is a DMA command as the name
>>> implies, so that eliminates the possibility of polling-related paths in
>>> ata_sff_interrupt (libata-sff.c).
>>>
>>> I'll flip some of my machines to the icky slow boring piix mode, rather
>>> than sexy AHCI mode :) to see if I can reproduce.  I have had a feeling
>>> that we needed a more sophisticated IRQ handling setup, this may be what
>>> was needed.  Lost interrupt recovery should occur faster than 30 seconds
>>> in any case, and should not require a hard reset if the hardware
>>> functions just fine outside of the lost-interrupt / race that just
>>> occurred.
>>
>> Yeap, there is a race condition with clearing which I don't think we
>> can solve completely but with some modification I think we can at
>> least cover known failure cases.
>>
>> For longer term, I don't think we can solve this by diddling with the
>> SFF registers.  The interface is just way too ancient and horrid to
>> build anything reliable on top of.  I'm planning on implementing
>> smarter IRQ storm handling and stepped timeouts for ATA commands.
>
> A tester on this bug
>        http://bugzilla.kernel.org/show_bug.cgi?id=15537
> seemed to find success with the patch.

Thanks for the Update!

I will wait some more and then test rc-2.

Best
Zeno
