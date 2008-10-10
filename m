Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbYJJOr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbYJJOr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbYJJOrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:47:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:42777 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbYJJOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BPwCZuUdklRArBigyaT5k/5pZaVqbDo4lQDmrNw1kfeykXpgIRcZh5AfpYgoPqPdGb
         BawwydFEevubIHL7j9SWszWdC7KOTGKa6c9jUy0wQDB3BgDxolAUI72SYgAat+lDLdhR
         2CGoV2wzVtuAutbbeb7az3KcRL3tGuinGMSIo=
Message-ID: <c62985530810100747m1094590ei5225f3a62e3d2248@mail.gmail.com>
Date: Fri, 10 Oct 2008 16:47:46 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 6/6] tracing/fastboot: Print ktime of sched events when boot tracing
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081010140534.GB13137@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010123450.8D3E6D1BCF0@perso1.free.fr>
	 <20081010140534.GB13137@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/10 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> When we use the boot tracer, we want the sched events to be printed
>> with the same timestamp than initcall events. So we have to create a
>> new type of entry which contains sched event attributes and the ktime
>> of the creation of the entry. Then the output is handled by the boot
>> tracer.
>
> hm, i think that's unnecessary duplication. Please extend the context
> switch trace entries to be useful for the boot tracer as well:
>

Ok. I will change it in V2.

> also, ktime_get() can be a quite complex function with dependency on
> xtime_lock - that inverts with the rq lock - so this can lock up
> sporadically when called from within the scheduler.
> it would be _much_ simpler to standardize the initcall timestamps on
> cpu_clock() instead. That too is a good global clock and starts at zero
> during bootup. Ok?

Hmm. Ok, I will pick what I saw about cpu_clock() in printk.c

> Your other patches look good and i've applied them to
> tip/tracing/fastboot:
>
>  3981ce9: tracing/fastboot: use sched switch tracer from boot tracer
>  563582a: tracing/ftrace: remove unused code in sched_switch tracer
>  d25b1ce: tracing/ftrace: fix a race condition in sched_switch tracer

Thanks. But are you really sure about d25b1ce?
Steven suggested some changes. But it doesn't matter, I can apply his
suggestions on top of this applied patch.
