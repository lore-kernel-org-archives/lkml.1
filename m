Return-Path: <linux-kernel-owner+w=401wt.eu-S1162192AbYCSWqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162192AbYCSWqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936747AbYCSVQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:16:30 -0400
Received: from gw.goop.org ([64.81.55.164]:47616 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936743AbYCSVQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:16:29 -0400
Message-ID: <47E181D9.3060802@goop.org>
Date: Wed, 19 Mar 2008 14:12:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <patchbomb.1205797011@localhost> <20080319190536.GA11432@elte.hu> <20080319194648.GA20088@elte.hu> <47E17171.9090108@goop.org> <20080319200931.GA24828@elte.hu>
In-Reply-To: <20080319200931.GA24828@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> i've uninlined it and has trickled that through your series.
>>>       
>> I build 32-bit PAE all the time.  I guess the difference is your build 
>> is !PARAVIRT?
>>     
>
> yes, randconfig triggered it rather quickly. Bad config attached. (it 
> now builds fine)
>
> 	Ingo
>   

This patch applied on top of everything else is sufficient to fix the 
problem for me:

Subject: x86: fix build problem in pud_populate without CONFIG_PARAVIRT

asm/paravirt.h ends up including linux/sched.h, which pud_populate needs
for its reference to current.  Specifically include linux/sched.h for it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgalloc.h |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -4,6 +4,7 @@
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
+#include <linux/sched.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>

