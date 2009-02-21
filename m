Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZBUJZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZBUJZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 04:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZBUJY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 04:24:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:59079 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZBUJY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 04:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T/xcpag/FbhsSWPUfjN1syXIlDMUdFOG0DmmNX1U/ZjlQVJJCfF14/4GMX959xo3O+
         NlO9LbWq3A5lERSJWHF28DP7xmQx5oeHW364O3RjCaof89s5gYpqc5IeFtACwug0BmuH
         FQqLE/ChlrVvByXd03fwOFsrHq1vXh3zLjviQ=
MIME-Version: 1.0
In-Reply-To: <20090211152342.GA16550@elte.hu>
References: <a5f59d880902100542x7243b13fuf40e7dd21faf7d7a@mail.gmail.com>
	 <20090210141405.GA16147@elte.hu>
	 <a5f59d880902110604g40cf17b5w92431f60e6f16fa4@mail.gmail.com>
	 <20090211145525.GB10525@elte.hu> <20090211152342.GA16550@elte.hu>
Date: Sat, 21 Feb 2009 17:24:56 +0800
Message-ID: <a5f59d880902210124wf5cc82dtd2b7cd6eacdd2230@mail.gmail.com>
Subject: Re: Using module private memory to simulate microkernel's memory 
	protection
From: Pengfei Hu <hpfei.cn@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder why kmemcheck has so many version. Can you tell me the
relation between them? My main target of this patch is checking
dangling pointer. But the fulll checking of dangling pointer is very
difficult. It need tracking reference of a memory. I only know NuMega
BoundsChecker can do this. Valgrind uses another method to check it.
It always allocate different address until consume all the available
address. Then it will loop again. So this method is not complete
enough. My patch can't really check dangling pointer. It can only
limit dangling pointer inside its own module and avoid the worst case:
one module write other module's memory randomly.

Kmemcheck track every access of allocating memory. But it can't track
reference of local variable. I think only instrumentation can do this
job. GCC bounds checking can error of check out of range. But it can't
check dangling pointer. I want to add this feature to it. GCC bounds
checking's instrumentation is at tree level. So it can't be used in
other complier. I want make instrumentation at source code. So it can
be used in other complier and platform. I know a unit test software
use this method to check coverage. If we can make instrumentation at
source code, then we will get the most flexibility.

I'll be very happy if my patch can be combined with kmemcheck. I don't
know if Vegard Nossum admit my idea. What should I do next?

linux/kernel/git/vegard/kmemcheck.gi
linux/kernel/git/x86/linux-2.6-kmemcheck-4.git
linux/kernel/git/x86/linux-2.6-kmemcheck-v2.git
linux/kernel/git/x86/linux-2.6-kmemcheck-v3.git
linux/kernel/git/x86/linux-2.6-kmemcheck.git

>
> Kmemcheck uses debug traps to execute a single instruction, and thus gets
> finer grained control of what is visible to a task.
>
>        Ingo
>



-- 
Regards,
Pengfei
