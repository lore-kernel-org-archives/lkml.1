Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbXLRMHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbXLRMHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXLRMHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:07:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbXLRMHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:07:01 -0500
Message-ID: <4767B78A.5030903@redhat.com>
Date: Tue, 18 Dec 2007 10:05:30 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 7/21] [PATCH] unify common parts of processor.h
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <20071218114504.GA22832@elte.hu>
In-Reply-To: <20071218114504.GA22832@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
> 
>> This patch moves the pieces of processor_32.h and processor_64 that 
>> are equal to processor.h. Only what's exactly the same is moved 
>> around, the rest not being touched.
> 
> argh, it doesnt even build cleanly:
> 
>  In file included from include/linux/elf.h:6,
>                   from include/linux/module.h:14,
>                   from include/linux/crypto.h:21,
>                   from arch/x86/kernel/asm-offsets_32.c:7,
>                   from arch/x86/kernel/asm-offsets.c:2:
>  include/asm/elf.h:286: warning: 'struct mm_struct' declared inside parameter list
>  include/asm/elf.h:286: warning: its scope is only this definition or declaration, which is probably not what you want
> 
> due to zapping this bit of include/asm-x86/processor_32.h:
> 
>  -/* Forward declaration, a strange C thing */
>  -struct task_struct;
>  -struct mm_struct;
> 
> 	Ingo
> 
I'll test it with your config, and repost.
