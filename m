Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYJUAhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYJUAhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYJUAg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:36:58 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63185 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYJUAg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:36:57 -0400
Message-ID: <48FD22D1.2060607@mxs.nes.nec.co.jp>
Date: Tue, 21 Oct 2008 09:31:13 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, ebiederm@xmission.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com
Subject: Re: [PATCH] declare vmlist to fix ia64 build breakage in kexec core
References: <20081020233438.GG15771@ldl.fc.hp.com> <20081020235258.GH15771@ldl.fc.hp.com>
In-Reply-To: <20081020235258.GH15771@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alex, Tony,

Alex Chiang wrote:
> Oh whoops, I see that Tony Luck already sent a patch for this
> directly to Linus.

Thank you for fixing a bug contained in my patch.


Thanks
Ken'ichi Ohmichi

> [Sorry for the noise, but I didn't realize this until I decided
> to browse through my lkml folder, as Tony's patch hasn't been
> pushed out yet.]
> 
> /ac
> 
> * Alex Chiang <achiang@hp.com>:
>> Commit acd99dbf54020f5c80b9aa2f2ea86f43cb285b02 (kdump: add
>> vmlist.addr to vmcoreinfo for x86 vmalloc translation) broke the
>> ia64 build in this fashion:
>>
>> kernel/kexec.c: In function `crash_save_vmcoreinfo_init':
>> kernel/kexec.c:1374: error: `vmlist' undeclared (first use in this function)
>> kernel/kexec.c:1374: error: (Each undeclared identifier is reported only once
>> kernel/kexec.c:1374: error: for each function it appears in.)
>> kernel/kexec.c:1410: error: dereferencing pointer to incomplete type
>> make[1]: *** [kernel/kexec.o] Error 1
>>
>> Adding the proper include fixes the build.
>>
>> Signed-off-by: Alex Chiang <achiang@hp.com>
>> ---
>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>> index 777ac45..ac0fde7 100644
>> --- a/kernel/kexec.c
>> +++ b/kernel/kexec.c
>> @@ -30,6 +30,7 @@
>>  #include <linux/pm.h>
>>  #include <linux/cpu.h>
>>  #include <linux/console.h>
>> +#include <linux/vmalloc.h>
>>  
>>  #include <asm/page.h>
>>  #include <asm/uaccess.h>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

