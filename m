Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYDMJfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYDMJfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYDMJf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:35:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:37182 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbYDMJf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=cVuc4eT13xCMRw8rut+KW0f2HOHdTCpWMywLRXIBH5EcbZ0xsChDOmzwo0q6SUdeydlTcx9hawSEvRzzhfdR3JDcXw+YH7DiosCA7alfEzL5pOKNORPKUUWSkknW6fOMMSKvDwCu+1iUCIIXfNcm/IhuKSRM7yVoFJbUlyFnXxw=
Message-ID: <4801D302.8070005@gmail.com>
Date: Sun, 13 Apr 2008 11:31:46 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: ijc@hellion.org.uk, tglx@linutronix.de,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: *_pagetable_setup_[start,done] crap ?
References: <4800E134.8040602@gmail.com> <20080413074225.GF20332@elte.hu>
In-Reply-To: <20080413074225.GF20332@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar pisze:
> * Jacek Luczak <difrost.kernel@gmail.com> wrote:
> 
>> Ohh... and prototypes are wrong:
>> diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
>> index 6cbc520..2167879 100644
>> --- a/include/asm-x86/pgtable_32.h
>> +++ b/include/asm-x86/pgtable_32.h
>> @@ -204,8 +204,8 @@ do {                                                \
>>   */
>>  #define update_mmu_cache(vma, address, pte) do { } while (0)
>>
>> -void native_pagetable_setup_start(pgd_t *base);
>> -void native_pagetable_setup_done(pgd_t *base);
>> +extern void native_pagetable_setup_start(pgd_t *base) __init;
>> +extern void native_pagetable_setup_done(pgd_t *base) __init;
> 
> while generally it's nice to add 'extern' to prototypes, it's not an 
> outright bug to not have it. Also, __init is a must-have in the 
> definition only - it should not be added to the prototype.
> 

Sounds reasonably. Sorry for calling something crap. When I slept well it looks fine and clear for me.

-Jacek
