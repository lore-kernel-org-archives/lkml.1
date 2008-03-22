Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYCVUb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYCVUb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 16:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYCVUbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 16:31:50 -0400
Received: from gw.goop.org ([64.81.55.164]:35312 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbYCVUbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 16:31:49 -0400
Message-ID: <47E56BBA.2000803@goop.org>
Date: Sat, 22 Mar 2008 13:27:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify sync_test_bit()
References: <47DA3DC0.76E4.0078.0@novell.com> <20080321111826.GC20420@elte.hu>
In-Reply-To: <20080321111826.GC20420@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jan Beulich <jbeulich@novell.com> wrote:
>
>   
>> There really is no need for a redundant implementation here, just keep 
>> the alternative name for allowing consumers to use consistent naming.
>>     
>
>   
>> -	__asm__ __volatile__("btl %2,%1\n\tsbbl %0,%0"
>> -			     :"=r" (oldbit)
>> -			     :"m" (ADDR),"Ir" (nr));
>>     
>
>   
>> +#define sync_test_bit test_bit
>>     
>
> thanks, applied.

Please use this instead.

    J

Subject: x86: use macro parameters on sync_test_bit

Using a naked parameterless macro could lead to other tokens being
unexpectedly replaced.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/sync_bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/include/asm-x86/sync_bitops.h
+++ b/include/asm-x86/sync_bitops.h
@@ -123,7 +123,7 @@
 	return oldbit;
 }
 
-#define sync_test_bit test_bit
+#define sync_test_bit(nr, addr) test_bit(nr, addr)
 
 #undef ADDR
 


