Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYKHATt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYKHATt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYKHATk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 19:19:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49498 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbYKHATj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 19:19:39 -0500
Message-ID: <4914DAEE.2050301@redhat.com>
Date: Fri, 07 Nov 2008 19:18:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, maneesh@in.ibm.com,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH] kprobe: increase kprobe_hash_table size
References: <4914D2DE.9030603@redhat.com> <20081107155646.b375413e.akpm@linux-foundation.org>
In-Reply-To: <20081107155646.b375413e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> On Fri, 07 Nov 2008 18:44:30 -0500 Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Increase the size of kprobe hash table to 512. It's useful when hundreds
>> of kprobes were used in the kernel because current size is just 64.
>>
> 
> "useful" is a bit vague.  How big is the problem which this solves, and
> how well did it solve it?

For example, when probing enters and exits of syscall-related functions,
we need more than 500 probes. In that case, each hlist would have 8
elements in average. With this patch, the hlist would have 1 element in
average.

I agree that there may be many opinions about what is the best suited size.
Why I chose 512 was that I thought the table (byte) size was less than or
equal 4096 even on 64-bit arch.

> See, someone (me) needs to decide whether to merge this and if so,
> whether to merge it into 2.6.29, 2.6.28, 2.6.27.x, 2.6.26.x and
> 2.6.25.x.  I'll need more information to make that decision, but I do
> not have it.

I think this improves performance just a bit.
So I think it would not be needed for 2.6.27.x or older kernel.

Thank you,

> 
>> --- 2.6.28-rc3.orig/kernel/kprobes.c
>> +++ 2.6.28-rc3/kernel/kprobes.c
>> @@ -49,7 +49,7 @@
>>  #include <asm/errno.h>
>>  #include <asm/uaccess.h>
>>
>> -#define KPROBE_HASH_BITS 6
>> +#define KPROBE_HASH_BITS 9
>>  #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
> 
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

