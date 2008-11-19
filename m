Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbYKSNte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbYKSNte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYKSNtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:49:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:58650 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbYKSNtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Qxl4eHXdrGyMkrJBcfOgsQ485z76rRsgynZsU2aBp1RNHpB3sHRulYb23Egp4ArFm8
         uXEIeQmxhtTJcwCdjRPPMqMxyfKFXeHao9Cc0ZK7bkl1y7qOKlnePf6aD7ReMV07+2/E
         HrBCbR0kkvPxOynup/MUDyk6K/8Sp3GQzha3c=
Message-ID: <8bd0f97a0811190549s4a5776b1yacc8508d9d17b5c5@mail.gmail.com>
Date: Wed, 19 Nov 2008 08:49:08 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] asm/generic: fix bug - kernel fails to build when enable some common audit code on Blackfin
Cc: "Bryan Wu" <cooloney@kernel.org>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081118223308.396ec63b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226991829-30641-1-git-send-email-cooloney@kernel.org>
	 <20081118223308.396ec63b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 01:33, Andrew Morton wrote:
> On Tue, 18 Nov 2008 15:03:49 +0800 Bryan Wu wrote:
>> From: Mike Frysinger <vapier.adi@gmail.com>
>> If you enable some common audit code, the kernel fails to build.
>>
>> In file included from lib/audit.c:17:
>> include/asm-generic/audit_write.h:3: error: '__NR_swapon' undeclared here (not in a function)
>> make[1]: *** [lib/audit.o] Error 1
>> make: *** [lib] Error 2
>>
>> So do not use __NR_swapon if it isnt defined for a port.
>>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  include/asm-generic/audit_write.h |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/asm-generic/audit_write.h b/include/asm-generic/audit_write.h
>> index f10d367..c5f1c2c 100644
>> --- a/include/asm-generic/audit_write.h
>> +++ b/include/asm-generic/audit_write.h
>> @@ -1,6 +1,8 @@
>>  #include <asm-generic/audit_dir_write.h>
>>  __NR_acct,
>> +#ifdef __NR_swapon
>>  __NR_swapon,
>> +#endif
>>  __NR_quotactl,
>>  __NR_truncate,
>>  #ifdef __NR_truncate64
>
> hrm.
>
> Should blackfin define __NR_swapon instead?  afacit
> include/asm/unistd.h is an exported-to-userspace header, so the
> architecture should export __NR_swapon to prevent userspace build
> failures?

i dont think ports should be forced to define syscalls they dont
support.  no-mmu cant do swap, so Blackfin doesnt define it ...
-mike
