Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYEPMJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYEPMJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYEPMJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:09:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYEPMJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:09:30 -0400
Date: Fri, 16 May 2008 14:09:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/xen: fix arbitrary_virt_to_machine()
Message-ID: <20080516120911.GE11718@elte.hu>
References: <482C47B4.76E4.0078.0@novell.com> <482C3360.1040309@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C3360.1040309@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Jan Beulich wrote:
>> While I realize that the function isn't currently being used, I still
>> think an obvious mistake like this should be corrected.
>>
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>>
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -60,7 +60,7 @@ xmaddr_t arbitrary_virt_to_machine(unsig
>>  {
>>  	unsigned int level;
>>  	pte_t *pte = lookup_address(address, &level);
>> -	unsigned offset = address & PAGE_MASK;
>> +	unsigned offset = address & (PAGE_SIZE - 1);
>>   
>
> Yeah.  But I'd prefer "~PAGE_MASK".

ok - queued up the patch below in -tip.

	Ingo

----------------------->
Subject: x86/xen: fix arbitrary_virt_to_machine()
From: "Jan Beulich" <jbeulich@novell.com>
Date: Thu, 15 May 2008 13:24:52 +0100

While I realize that the function isn't currently being used, I still
think an obvious mistake like this should be corrected.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/xen/mmu.c
===================================================================
--- linux.orig/arch/x86/xen/mmu.c
+++ linux/arch/x86/xen/mmu.c
@@ -60,7 +60,7 @@ xmaddr_t arbitrary_virt_to_machine(unsig
 {
 	unsigned int level;
 	pte_t *pte = lookup_address(address, &level);
-	unsigned offset = address & PAGE_MASK;
+	unsigned offset = address & ~PAGE_SIZE;
 
 	BUG_ON(pte == NULL);
 
