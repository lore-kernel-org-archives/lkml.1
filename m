Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbZCXP0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbZCXP0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbZCXPZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:25:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:45083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741AbZCXPZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:25:55 -0400
Message-ID: <49C8FAC4.6060508@kernel.org>
Date: Wed, 25 Mar 2009 00:22:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org>
In-Reply-To: <49C300D8.5080204@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 15:22:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Martin.
> 
> Sorry about the delay.
> 
> Martin Schwidefsky wrote:
>> We do have a problem with #2, the dynamic percpu patches currently
>> breaks s390. But the nice thing is that we can now get rid of the GOTENT
>> relocation for the percpu symbols. If the code is changed to use
>> RELOC_HIDE for the SHIFT_PERCPU_PTR define, everything works just fine.
>> Patch attached. Nice works guys.
>>
>> Subject: [PATCH] s390: percpu access.
>>
>> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>>
>> With the dynamic percpu allocator there is no need anymore to play
>> tricks with the GOTENT relocation for the access to the percpu
>> symbols. A simple RELOC_HIDE gets the job done.
> 
> Hmm... I don't quite get it.  The GOTENT was to work around large
> offsets for modules, right?  Can you please explain what changed by
> the dynamic percpu allocator?
> 
>> +#define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
> 
> Hmm... @var already has per_cpu__ prefix when the above macro is
> invoked, so doing per_cpu_var() on it again wouldn't work.  If simple
> RELOC_HIDE works, you should be able to simply drop the above
> definition.  The generic percpu.h will define it.

Ping.

-- 
tejun
