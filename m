Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYKJQbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYKJQbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYKJQbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:31:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:3775 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYKJQbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=evnxDyMTqC68K1RWrFO7Jdvdj3b9ukemLE/YkUfO36tBhmqb+P95hHVEP2NiAkLsQS
         CkMN+vlFvlFfbKJmLopmClCDLnqlqfxe/jwDJxArpmjcm7XZbEIJm8DBWF2ZZl4YHzRy
         ljASgQPCn5TH7J6VvnCOGyaWEzkPCAfNWGYFk=
Date: Mon, 10 Nov 2008 19:31:35 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
Message-ID: <20081110163135.GD16522@localhost>
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com> <20081110161133.GB16522@localhost> <49185F08.9030705@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49185F08.9030705@cosmosbay.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Eric Dumazet - Mon, Nov 10, 2008 at 05:19:20PM +0100]
...
>>
>> Hi Eric,
>>
>> for the record
>>
>> 	apic_write(APIC_LVTPC, APIC_DM_NMI);
>>
>> is not just 'unmask' but also *zeroify* (not sure if I wrote this
>> word right :) all fields when the origianl code was just 'unmasking'
>> TPC register
>>
>> 	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
>>
>> that is why apic_read() was in former.
>>
>
> Well, given that APIC_LVTPC is initialized by oprofile init to value APIC_DM_NMI,
> I avoid an apic_read() and just write APIC_DM_NMI again...
>
> Presumably, apic_read(APIC_LVTPC) should return APIC_DM_NMI or APIC_DM_NMI|APIC_LVT_MASKED
>
> Thanks
>

Yes, just grepped the sources -- it seems nobody else touching
this register indeed.
		- Cyrill -
