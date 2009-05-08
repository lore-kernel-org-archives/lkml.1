Return-Path: <linux-kernel-owner+w=401wt.eu-S1763089AbZEHRFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763089AbZEHRFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZEHRE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:04:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45557 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbZEHREz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:04:55 -0400
Message-ID: <4A046550.6050007@zytor.com>
Date: Fri, 08 May 2009 10:01:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com
Subject: Re: [PATCH 03/14] x86, config: change defaults PHYSICAL_START and
 PHYSICAL_ALIGN
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-4-git-send-email-hpa@linux.intel.com> <20090508073606.GC12808@uranus.ravnborg.org>
In-Reply-To: <20090508073606.GC12808@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 039c3f0..13b3a5a 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1455,17 +1455,20 @@ config KEXEC_JUMP
>>  
>>  config PHYSICAL_START
>>  	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
>> -	default "0x1000000" if X86_NUMAQ
>> -	default "0x200000" if X86_64
>> -	default "0x100000"
>> +	default "0x400000" if EMBEDDED
>> +	default "0x1000000"
>>  	---help---
>>  	  This gives the physical address where the kernel is loaded.
>>  
>>  	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
>>  	  bzImage will decompress itself to above physical address and
>> -	  run from there. Otherwise, bzImage will run from the address where
>> -	  it has been loaded by the boot loader and will ignore above physical
>> -	  address.
>> +	  run from there. Otherwise, bzImage will run from the either
>> +	  the above physical address or where it has been loaded by
>> +	  the boot loader, whichever is higher.
>> +
>> +	  For embedded machines with very small memory (less than
>> +	  about 24 MB) this may need to be adjusted downward from the
>> +	  default value of 0x1000000 (16 MB).
> 
> But in the above you say that default is "0x400000" if EMBEDDED
> That is in contradiction with the help - no?
> 

0x1000000 really should be the default value.  The "0x400000" if
EMBEDDED I put in to make the risk of throwing something surprising on
embedded people somewhat smaller; I'm not sure if it should go away
entirely.  Even if it doesn't, I do think referring to 16 MB as the
"default value" is right.

BTW, it would be nice to have Kconfig deal with:

a) numbers that must be powers of 2;
b) suffixes like "16M" instead of "0x1000000".  ;)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

