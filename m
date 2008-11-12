Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbYKLK6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbYKLK6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKLK60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:58:26 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:21829 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbYKLK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p2NwjuFOZfmlBL5MC+DS8OO3WcTkErJwk9ZFoWeWW7gQK1ajU6pDXpjAL0d1EFhCsu
         RXKzbMXeID313psGWq1W2gfGRO2nvA4xb73SX2UQFqfkKpTwYEx5fezzEQZgxxRVbIWQ
         BbYQFpHCCYgtfWjgvKqrNV6nXwRkfx1wyE/rg=
Message-ID: <c62985530811120258p98e5909iab6c59f21744afd3@mail.gmail.com>
Date: Wed, 12 Nov 2008 11:58:24 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing/fastboot: Use the ring-buffer timestamp for initcall entries
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20081112092548.GE4748@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491A062A.8080406@gmail.com> <20081112092548.GE4748@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/12 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: Split the boot tracer entries in two parts: call and return
>>
>> Now that we are using the sched tracer from the boot tracer, we want
>> to use the same timestamp than the ring-buffer to have consistent
>> time captures between sched events and initcall events. So we get
>> rid of the old time capture by the boot tracer and split the
>> initcall events in two parts: call and return. This way we have the
>> ring buffer timestamp of both.
>>
>> There is an example of a trace in attachment.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  include/trace/boot.h      |   31 ++++++++---
>>  init/main.c               |   32 ++++++------
>>  kernel/trace/trace.h      |   17 ++++--
>>  kernel/trace/trace_boot.c |  123 ++++++++++++++++++++++++++++++++++-----------
>>  4 files changed, 144 insertions(+), 59 deletions(-)
>
> applied to tip/tracing/fastboot, thanks Frederic!
>
> one small detail, do we need these messages in the boot tracer:
>
>  ##### CPU 1 buffer started ####
>
> they are helpful for latency traces but might be confusing for boot
> traces. (they lose their attraction after having seen a dozen of them)
>
>        Ingo
>


Yes. I'm using the default formatting output in trace.c so perhaps
there is some iter flag I should dynamically remove
from the boot tracer to avoid that or perhaps I may format a custom
output for sched entries for the boot tracer.
I will see that....

By the way Arjan, does the actual state of the boot tracer match your needs?
You can find an example of its trace here:
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=74239072830ef3f1398edeb1bc1076fc330fd4a2
