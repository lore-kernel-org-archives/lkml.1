Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890Ab0AZHXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0AZHXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412Ab0AZHXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:23:52 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:38697 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0AZHXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:23:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QQTizp673ikJQXr3RFxU9ixldT1bhPrujhsIAc4cheuDmNy4cZA4UnUUU/zdXiIFUm
         DQNNf87MnwjK03Zh5/17wtMZ3d4ZCkNb8vq6D3+ba74vKL/8s7lguhECwxuIsNCmufWy
         CStgIXjJbR/GrBuSieVmT9XLdpdGikmk8Jn8g=
MIME-Version: 1.0
In-Reply-To: <20100125145745.GE24418@ghostprotocols.net>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1264167553-6510-13-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100125022351.GD24418@ghostprotocols.net>
	 <a6b9f31a1001250647k7273ab80j771d673595d3ad80@mail.gmail.com>
	 <20100125145745.GE24418@ghostprotocols.net>
Date: Tue, 26 Jan 2010 16:17:39 +0900
X-Google-Sender-Auth: 47e720cadfdff961
Message-ID: <a6b9f31a1001252317l17419428u6b7b8600d9c47dfa@mail.gmail.com>
Subject: Re: [PATCH 12/12] Revert "perf record: Intercept all events"
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 23:57, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Mon, Jan 25, 2010 at 11:47:40PM +0900, Hitoshi Mitake escreveu:
>> On Mon, Jan 25, 2010 at 11:23, Arnaldo Carvalho de Melo
>> <acme@infradead.org> wrote:
>> > Em Fri, Jan 22, 2010 at 10:39:13PM +0900, Hitoshi Mitake escreveu:
>> >> This reverts commit f5a2c3dce03621b55f84496f58adc2d1a87ca16f.
>> >>
>> >> This patch is required for making "perf lock rec" work.
>> >> The commit f5a2c3dce0 changes write_event() of builtin-record.c .
>> >> And changed write_event() sometimes doesn't stop with perf lock rec.
>> >>
>> >> I'm researching what makes write_event() loop infinity,
>> >> and noticed that there are some events with event_t->header.size == 0.
>> >> But the detail of the problem,
>> >> like kind of these events, isn't clear...
>> >>
>> >> If you know something related to this problem,
>> >> could you tell me, Arnaldo?
>> >
>> > Well, this will have to wait for somebody to remove the need for
>> > intercepting those events, reverting this patch fixes your tool while
>> > breaking others that then won't catch all the events.
>>
>> Yes, this patch is too egoistic thing and temporary solution.
>> I have to consider and modify 'perf lock'.
>
> Hey, don't get me wrong, the situation is fragile, either way something
> will get broken and that isn't your fault, its just that we need some
> sensible and non racy way to inject the buildids at 'perf record' time.

Thanks for correcting my misunderstand :)

>
> The way I did it, long ago, intercepting events in 'perf record' to
> build a DSO list to then at 'perf record' exit to insert a table at the
> perf.data file header looks too intrusive now, so we need some other way
> that doesn't have this problem and its not racy.

I see. I'll look some other way, too.
Or if you find it, could you tell me?

>
>> > I'll get 'perf regtest' out with some initial tests then try to get some
>> > proposal for injecting the buildid, if found in a DSO, via
>> > PERF_RECORD_MMAP, lets see how this goes...
>>
>> What does "DSO" mean? Sorry, I'm not good at English...
>
> As Peter said, anything that that is on an executable MMAP.

I understood :) Thanks, Peter and Arnaldo.


Thanks,
	Hitoshi
