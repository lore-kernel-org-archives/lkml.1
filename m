Return-Path: <linux-kernel-owner+w=401wt.eu-S1751578AbXE3Fsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbXE3Fsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 01:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXE3Fsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 01:48:30 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:39649 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXE3Fs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 01:48:29 -0400
Message-ID: <465D1020.3030605@cosmosbay.com>
Date: Wed, 30 May 2007 07:48:16 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] m68k: runtime patching infrastructure
References: <20070528191630.377693320@mail.of.borg>	<20070528191715.352919509@mail.of.borg> <20070529173818.fd94ae81.akpm@linux-foundation.org>
In-Reply-To: <20070529173818.fd94ae81.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 30 May 2007 07:48:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Mon, 28 May 2007 21:16:31 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
>> --- a/include/asm-m68k/module.h
>> +++ b/include/asm-m68k/module.h
>> @@ -1,7 +1,38 @@
>>  #ifndef _ASM_M68K_MODULE_H
>>  #define _ASM_M68K_MODULE_H
>> -struct mod_arch_specific { };
>> +
>> +struct mod_arch_specific {
>> +	struct m68k_fixup_info *fixup_start, *fixup_end;
>> +};
> 
> Here we use struct m68k_fixup_info.
> 
>> +#define MODULE_ARCH_INIT {				\
>> +	.fixup_start		= __start_fixup,	\
>> +	.fixup_end		= __stop_fixup,		\
>> +}
>> +
>>  #define Elf_Shdr Elf32_Shdr
>>  #define Elf_Sym Elf32_Sym
>>  #define Elf_Ehdr Elf32_Ehdr
>> +
>> +
>> +enum m68k_fixup_type {
>> +	m68k_fixup_memoffset,
>> +};
>> +
>> +struct m68k_fixup_info {
>> +	enum m68k_fixup_type type;
>> +	void *addr;
>> +};
> 
> and later we define it.
> 
> How come it doesn't spit warnings?
> 
> I think it could be tightened up even if it happens not to warn?


struct a {
	struct not_yet_defined *start, *end;
};

struct not_yet_defined {
	void *foo;
};

Is a valid and gives no warnings.

Still I didnt tried to compile a m68k kernel, so I guess I shouldnt speak here :)
