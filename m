Return-Path: <linux-kernel-owner+w=401wt.eu-S934949AbZDHRdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949AbZDHRdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934914AbZDHRdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:33:01 -0400
Received: from gw.goop.org ([64.81.55.164]:35436 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934954AbZDHRc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:32:59 -0400
Message-ID: <49DCDFC9.9000505@goop.org>
Date: Wed, 08 Apr 2009 10:32:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH] Allow preemption during lazy mmu updates
References: <1238176963-21093-1-git-send-email-jeremy@goop.org> <20090408145440.GN12931@elte.hu>
In-Reply-To: <20090408145440.GN12931@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>  include/asm-frv/pgtable.h          |    4 +-
>>     
>
> Needs the ack of the FRV arch maintainer both for content and for 
> flow (i.e. via x86 tree). If any second thoughts are expressed about 
> the flow then this needs to go on separate tracks.
>   

I don't know why frv defines this; its just cut'n'paste from the default 
no-op implementation in asm-generic/pgtable.h.  (h8300 too, it seems.)

David, do you have a specific reason for defining 
arch_enter/leave_lazy_cpu_mode() in asm-frv/pgtable.h?  It seems to have 
come in with 28936117af849b8c2fca664a41ea7651a0d99591 "FRV: Add some 
missng lazy MMU hooks for NOMMU mode".  The intention was that 
asm-generic/pgtable.h should supply the default definitions; is that 
incompatible with nommu or something?

Yoshinori-san, do you have a specific reason for defining 
arch_enter/leave_lazy_cpu_mode() in asm-h3800/pgtable.h?  It seems to 
have come in with c728d60455e8e8722ee08312a75f38dd7a866b5e "h8300 
generic irq", which doesn't seem like a related change.

>>  include/asm-generic/pgtable.h      |   21 +++++++------
>>     
>
> Needs the ack of arch maintainers in general and a linux-arch 
> cross-post.
>   

asm-generic/pgtable.h defines the default no-op implementation which is 
used when the architecture has no particular use for the hook.  The only 
non-x86 definitions are frv and h3800, and they're both copies of the 
no-op definition.

In any case, if this series is a sticking point, we can easily drop it 
as the subsequent patches have no dependency on it.

    J
