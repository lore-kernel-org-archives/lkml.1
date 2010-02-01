Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0BARXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:23:33 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9851 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0BARXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:23:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=PuXTpHaTEdqebX1Wmkmw1fZd11FMq+PJavZiycn9x2HtRTzb79JnWratBEs5CkLTK
	xKl/mVhzDB7cx//apaHlw==
MIME-Version: 1.0
In-Reply-To: <1265042731.24455.232.camel@laptop>
References: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
	 <1265038508.24455.177.camel@laptop>
	 <1265040260.24455.200.camel@laptop>
	 <bd4cb8901002010814x12e5a26v195f13c63b0f7567@mail.gmail.com>
	 <1265042731.24455.232.camel@laptop>
Date: Mon, 1 Feb 2010 18:23:29 +0100
Message-ID: <bd4cb8901002010923q79fa82f5s90a8430b4c037a19@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bug in hw_perf_enable()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       Arjan van de Ven <arjan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 5:45 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-02-01 at 17:14 +0100, Stephane Eranian wrote:
>
>> Using perfmon on Core 2 on a 10s noploop:
>>
>> pfmon -eunhalted_reference_cycles,unhalted_core_cycles,cpu_clk_unhalted:bus
>>  noploop 10
>> noploop for 10 seconds
>> 23869090125 UNHALTED_REFERENCE_CYCLES
>> 23849336873 UNHALTED_CORE_CYCLES
>>  2652122099 CPU_CLK_UNHALTED:BUS
>
> Weird, I used:
>
>  while :; do :; done &
>  while :; do :; done &
>  while :; do :; done &
>  while :; do :; done &
>  perf stat -a -e r013c -e r013c sleep 4
>  killall bash
>
> Which gives:
>
>  Performance counter stats for 'sleep 4':
>
>  244235699509090  raw 0x13c
>  244235695558036  raw 0x13c
>
Strange. I am running mine on a Q6600.
What's yours?

>    4.005485333  seconds time elapsed
>
> And verified it used fixed counter 2 and general purpose counter 0 using
> sysrq-p.
>
> [523417.108402] CPU#0:   gen-PMC0 ctrl:  000000000053013c
> [523417.108403] CPU#0:   gen-PMC0 count: 000000ff80019948
> [523417.108405] CPU#0:   gen-PMC0 left:  000000007fffffff
> [523417.108407] CPU#0:   gen-PMC1 ctrl:  0000000000000000
> [523417.108409] CPU#0:   gen-PMC1 count: 0000000000000000
> [523417.108411] CPU#0:   gen-PMC1 left:  000000007fffb8a8
> [523417.108412] CPU#0: fixed-PMC0 count: 0000000000000000
> [523417.108414] CPU#0: fixed-PMC1 count: 0000000000000000
> [523417.108416] CPU#0: fixed-PMC2 count: 0000010db1db2117
>
> Using -linus, since that doesn't have any of the recent constraint
> patches in that would avoid us from using fixed-PMC2.
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
