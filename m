Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0BARWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:22:18 -0500
Received: from smtp-out.google.com ([216.239.33.17]:53515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab0BARWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:22:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Wc8bxno9mSp3oPjDzBzcpXD+QsGrSnTyCH7A+7eCxrmzM4WjToyEwl+erg+ztWFpD
	6/ZPIECg9XljFqRiMqxeA==
MIME-Version: 1.0
In-Reply-To: <1265042837.24455.234.camel@laptop>
References: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
	 <1265038508.24455.177.camel@laptop>
	 <bd4cb8901002010812x505b77b4h754f573e3bbfa615@mail.gmail.com>
	 <1265042837.24455.234.camel@laptop>
Date: Mon, 1 Feb 2010 18:22:06 +0100
Message-ID: <bd4cb8901002010922n5205e9e5s5e3497b40ee56ccd@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bug in hw_perf_enable()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 5:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-02-01 at 17:12 +0100, Stephane Eranian wrote:
>> > btw, I've also added the below, from what I can make from the docs
>> fixed
>> > counter 2 is identical to arch perf event 0x013c, as per table A-1
>> and
>> > A-7. Both are called CPU_CLK_UNHALTED.REF, except for Core2, where
>> > 0x013c is called CPU_CLK_UNHALTED.BUS.
>> >
>>
>> If you measure 0x013c in a generic counter or in fixed counter 2
>> it will count the same thing but not at the same rate.
>> This is true on Core2, Atom, Nehalem, Westmere. The ratio is the
>> clock/bus ratio.
>
> But for Nehalem and Westmere event 0x3c umask 0x01 is referred to as
> CPU_CLK_UNHALTED.REF_P (Tables A-2 and A-4),
>
_P means programmable (counter).

on my NHM:

pfmon -v -eunhalted_core_cycles,unhalted_reference_cycles,cpu_clk_unhalted:ref_p
 ./noploop 10
[FIXED_CTRL(pmc16)=0xaa0 pmi0=1 en0=0x0 any0=0 pmi1=1 en1=0x2 any1=0
pmi2=1 en2=0x2 any2=0] UNHALTED_CORE_CYCLES UNHALTED_REFERENCE_CYCLES
[PERFEVTSEL0(pmc0)=0x51013c event_sel=0x3c umask=0x1 os=0 usr=1
anythr=0 en=1 int=1 inv=0 edge=0 cnt_mask=0] CPU_CLK_UNHALTED
noploop for 10 seconds

29292225749 UNHALTED_CORE_CYCLES
29292249954 UNHALTED_REFERENCE_CYCLES
 1331465398 CPU_CLK_UNHALTED:REF_P

REF_P runs at 133MHz. Core at 2.93GHz.


> Fixed Counter 2 is referred to as CPU_CLK_UNHALTED.REF (Table A-7).
>
> For Core2 and Atom (Table A-8, A-9) it is called CPU_CLK_UNHALTED.BUS,
> for these entries there is talk about a fixed ratio.
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
