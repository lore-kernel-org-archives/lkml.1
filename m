Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYB0OXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYB0OXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 09:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYB0OX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 09:23:27 -0500
Received: from mail.suse.de ([195.135.220.2]:48805 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbYB0OX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:23:26 -0500
Message-ID: <47C572CA.2010604@suse.de>
Date: Wed, 27 Feb 2008 15:25:14 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] Fix alignment of early reservation for EBDA
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com>
In-Reply-To: <1203958478.20033.1239002461@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> On Sun, 24 Feb 2008 18:18:16 -0800, "H. Peter Anvin" <hpa@zytor.com>
> said:
>> Alexander van Heukelum wrote:
>>> early res: 3 [9f000-9ffff] EBDA
>>>
>>> Is it really necessary to force the allocation to a page boundary?
>> It is, but that rounding gets done in reserve_bootmem() anyway, so there 
>> is no need for the arch-specific code to do it.
>>
>> The 32-bit EBDA code hard-codes a size of 4K, which is probably equally 
>> wrong; my gut feel is that the right thing to do is to reserve from the 
>> EBDA up to the 640K mark (some BIOSes use an area like that for SMM 
>> stuff), possibly with some sanity checking.

It's not needed, the e820 maps are always correct for modern systems in
this case as far  as I know.


> 
>         /* reserve all memory between lowmem and the 1MB mark */
>         reserve_early(lowmem, 0x100000, "BIOS reserved");

The i386 kernel did this always, but I intentionally removed it from the
64bit kernel because all the modern BIOS seem to correctly report holes
in this area. Only didn't do it on i386 because there were some concerns
of very old systems not doing this correctly.

My suspicion is that modern Windows systems rely on this, that is why
BIOSes typically get it correct now.

I think it should be only undone if you have a concrete case where it
breaks not just based on someone's gut feel. Sure it's not a lot of
memory, but why waste memory unnecessarily?

-Andi

