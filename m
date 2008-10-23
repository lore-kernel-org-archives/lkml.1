Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYJWRun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYJWRun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbYJWRu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:50:28 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:28148 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbYJWRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N4x/jTVoKmBS7kDAhCw/YyFPJvKAwyQL5Ei3k+JUQOQ8sN0wgLFP+cfseXgr/bDbtI
         rlEOX4YuAP2kua9LABa6Arqc0g6Ktw6DXOGEWdd19miNPx0IyxPgCHbw7S39wczjg7Jb
         XN9nvtAhBGPt8q64BvE3P0zx4thgTRAEn0JXU=
Message-ID: <c62985530810230935t4b5e88bepfd48ca694bdd8eba@mail.gmail.com>
Date: Thu, 23 Oct 2008 18:35:14 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Cc: "Ingo Molnar" <mingo@elte.hu>, "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20081023163433.GA3160@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
	 <20081023121145.GB27984@x200.localdomain>
	 <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
	 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
	 <49008D12.5090204@gmail.com>
	 <Pine.LNX.4.64.0810231635440.18978@anakin>
	 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
	 <Pine.LNX.4.64.0810231727430.18978@anakin>
	 <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Alexey Dobriyan <adobriyan@gmail.com>:
> On Thu, Oct 23, 2008 at 07:27:48PM +0200, Frederic Weisbecker wrote:
>> When tracing is enabled, some arch have included <linux/irqflags.h>
>> on their <asm/system.h> but others like alpha or m68k don't.
>>
>> Build error on alpha:
>>
>> kernel/trace/trace.c: In function 'tracing_generic_entry_update':
>> kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
>> kernel/trace/trace.c: In function 'tracing_cpumask_write':
>> kernel/trace/trace.c:2145: error: implicit declaration of function 'raw_local_irq_disable'
>> kernel/trace/trace.c:2162: error: implicit declaration of function 'raw_local_irq_enable'
>> kernel/trace/trace.c: In function 'trace_die_handler':
>> kernel/trace/trace.c:3039: error: 'DIE_OOPS' undeclared (first use in this function)
>>
>> Build error on m68k:
>> http://kisskb.ellerman.id.au/kisskb/buildresult/50641/
>>
>>
>> Include it on kernel/trace/trace.c
>>
>> Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 78d5661..deb9684 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -34,6 +34,7 @@
>>
>>  #include <linux/stacktrace.h>
>>  #include <linux/ring_buffer.h>
>> +#include <linux/irqflags.h>
>
> Sure, except it doesn't fix anything.
>

Really? You mean only m68k or even on alpha?
