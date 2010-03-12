Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0CLAQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:16:20 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:44352 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0CLAQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SPwvb/b4+RTizbzWN+C8DbYihESFbntHoNiDYKepAxVFFig0r3sGSohvXzd6DIB6aP
         wUsyZmLxuXlFVCckJ1x9ubQAOUEe3gHYtzeEdJ9ExtRNkIiYuJtUz7xwFhlUqKamQl72
         nAF+0+IOFiEi1VWR42OBsXMxDSwxHlEUdI3q8=
Message-ID: <4B9987CD.4060907@garzik.org>
Date: Thu, 11 Mar 2010 19:16:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
CC: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.34
References: <20100301202330.GA14977@havoc.gtf.org> <alpine.LFD.2.00.1003091304400.3583@i5.linux-foundation.org> <4B96C7B2.3080008@garzik.org> <4B971F83.4030505@kernel.org>
In-Reply-To: <4B971F83.4030505@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2010 11:26 PM, Tejun Heo wrote:
> Hello, Linus, Jeff.
>
> On 03/10/2010 07:12 AM, Jeff Garzik wrote:
>> Coincedentally, it looks like someone else just reported the same
>> problem, with 2.6.34-rc1.
>>
>> It definitely sounds like a race.  READ DMA is a DMA command as the name
>> implies, so that eliminates the possibility of polling-related paths in
>> ata_sff_interrupt (libata-sff.c).
>>
>> I'll flip some of my machines to the icky slow boring piix mode, rather
>> than sexy AHCI mode :) to see if I can reproduce.  I have had a feeling
>> that we needed a more sophisticated IRQ handling setup, this may be what
>> was needed.  Lost interrupt recovery should occur faster than 30 seconds
>> in any case, and should not require a hard reset if the hardware
>> functions just fine outside of the lost-interrupt / race that just
>> occurred.
>
> Yeap, there is a race condition with clearing which I don't think we
> can solve completely but with some modification I think we can at
> least cover known failure cases.
>
> For longer term, I don't think we can solve this by diddling with the
> SFF registers.  The interface is just way too ancient and horrid to
> build anything reliable on top of.  I'm planning on implementing
> smarter IRQ storm handling and stepped timeouts for ATA commands.

Another ata_piix report on l-i & lkml indicates that 2.6.33 is fine and 
libata timeouts occur on 2.6.34-rc1.

I was able to reproduce once, during disk stress.  I think I can do so 
again and hopefully verify a fix.

	Jeff



