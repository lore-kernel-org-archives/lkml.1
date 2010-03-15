Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab0CONcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:32:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65467 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0CONcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H8R4JfMVzN838CKE0fozTvkSfXvjM/tNkCClk7hOAZFQNQjEmwGwBojKykZr44M+Rq
         MkxtMLAV8WHFz5/U3udax2dPRcEPuZp7CmozbrCPAMGPQlgUAVxU5pgXvETygIiEeK+d
         7ZDOXohpOq65RVi5/eKmljjYEWafe574UJk+Q=
Message-ID: <4B9E36D5.9080503@garzik.org>
Date: Mon, 15 Mar 2010 09:32:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [git patches] libata updates for 2.6.34
References: <20100301202330.GA14977@havoc.gtf.org>	 <alpine.LFD.2.00.1003091304400.3583@i5.linux-foundation.org>	 <4B96C7B2.3080008@garzik.org> <4B971F83.4030505@kernel.org>	 <4B9DA1BB.9010808@garzik.org>	 <40a4ed591003150033w5c416b28rfae989fa2ddf7305@mail.gmail.com>	 <4B9E30D5.2030001@garzik.org> <40a4ed591003150621h792f0a7ex793b54708166ffa0@mail.gmail.com>
In-Reply-To: <40a4ed591003150621h792f0a7ex793b54708166ffa0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 09:21 AM, Zeno Davatz wrote:
> On Mon, Mar 15, 2010 at 2:06 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>> On 03/15/2010 03:33 AM, Zeno Davatz wrote:
>>>
>>> On Mon, Mar 15, 2010 at 3:55 AM, Jeff Garzik<jeff@garzik.org>    wrote:
>>>>
>>>> On 03/09/2010 11:26 PM, Tejun Heo wrote:
>>>>>
>>>>> Hello, Linus, Jeff.
>>>>>
>>>>> On 03/10/2010 07:12 AM, Jeff Garzik wrote:
>>>>>>
>>>>>> Coincedentally, it looks like someone else just reported the same
>>>>>> problem, with 2.6.34-rc1.
>>>>>>
>>>>>> It definitely sounds like a race.  READ DMA is a DMA command as the
>>>>>> name
>>>>>> implies, so that eliminates the possibility of polling-related paths in
>>>>>> ata_sff_interrupt (libata-sff.c).
>>>>>>
>>>>>> I'll flip some of my machines to the icky slow boring piix mode, rather
>>>>>> than sexy AHCI mode :) to see if I can reproduce.  I have had a feeling
>>>>>> that we needed a more sophisticated IRQ handling setup, this may be
>>>>>> what
>>>>>> was needed.  Lost interrupt recovery should occur faster than 30
>>>>>> seconds
>>>>>> in any case, and should not require a hard reset if the hardware
>>>>>> functions just fine outside of the lost-interrupt / race that just
>>>>>> occurred.
>>>>>
>>>>> Yeap, there is a race condition with clearing which I don't think we
>>>>> can solve completely but with some modification I think we can at
>>>>> least cover known failure cases.
>>>>>
>>>>> For longer term, I don't think we can solve this by diddling with the
>>>>> SFF registers.  The interface is just way too ancient and horrid to
>>>>> build anything reliable on top of.  I'm planning on implementing
>>>>> smarter IRQ storm handling and stepped timeouts for ATA commands.
>>>>
>>>> A tester on this bug
>>>>         http://bugzilla.kernel.org/show_bug.cgi?id=15537
>>>> seemed to find success with the patch.
>>>
>>> Thanks for the Update!
>>>
>>> I will wait some more and then test rc-2.
>>
>> Can you test the patch, please?
>
> Sure. I done:
>
> /usr/src/linux>  sudo patch -p1<  teo
> patching file drivers/ata/libata-sff.c
> Hunk #1 FAILED at 1667.
> Hunk #2 FAILED at 1700.
> Hunk #3 FAILED at 1718.
> Hunk #4 FAILED at 1770.
> Hunk #5 FAILED at 1792.
> Hunk #6 FAILED at 1801.
> Hunk #7 FAILED at 1818.
> 7 out of 7 hunks FAILED -- saving rejects to file drivers/ata/libata-sff.c.rej
>
> Is that the expected outcome? Can I ignore the "failed" output?

With 7 out of 7 hunks failing, nothing got modified.

Is your source tree an unmodified, vanilla 2.6.34-rc1 tree?

	Jeff




