Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0BJN6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:58:12 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39282 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab0BJN6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:58:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=KD1rv9frMCq5dFkaZ01aDLXOSogFeNg84+zmMz5LaTWLVCnpjRJ9t7cZ6T2eahAoUs
         bjt0T7JSTrH4Cflf/b3AOkZjc7RlxfnJoDY6MjlBM8YLJmDacT/XLyeUA5xMKxe/qlXA
         StX9amwGw1Er1cd25hCnQjVeT7jkSxxtiY7BE=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1265808501.11509.300.camel@laptop>
References: <4b703957.0702d00a.6bf2.7b7d@mx.google.com>
	 <1265803166.11509.286.camel@laptop>
	 <bd4cb8901002100504i8e716e8ob845f692e031726f@mail.gmail.com>
	 <1265807830.11509.295.camel@laptop>
	 <1265808501.11509.300.camel@laptop>
Date: Wed, 10 Feb 2010 14:58:04 +0100
Message-ID: <7c86c4471002100558s1a744ae7h6b3837c786e03704@mail.gmail.com>
Subject: Re: [PATCH] perf_events: AMD event scheduling (v3)
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 2:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-02-10 at 14:17 +0100, Peter Zijlstra wrote:
>> On Wed, 2010-02-10 at 14:04 +0100, Stephane Eranian wrote:
>>
>> > > @@ -2268,7 +2268,7 @@ static inline int amd_is_nb_event(struct
>> > >        u64 val = hwc->config & K7_EVNTSEL_EVENT_MASK;
>> > >        /* event code : bits [35-32] | [7-0] */
>> > >        val = (val >> 24) | (val & 0xff);
>> > > -       return val >= 0x0e0;
>> > > +       return val >= 0xe00;
>> > >  }
>> > >
>> > I don't understand the change from 0xe0 to 0xe00.
>> > That's not the same thing at all.
>> > Event select is bits 0-7 + 32-35.
>>
>> OK that appears to be my bad, because you extended K7_EVNTSEL_EVENT_MASK
>> with bit 35 I thought NB events all had bit 35 set.
>>
>> But looking at the AMD docs it does indeed appear to start at 0xe0, and
>> there are no events with bit 35 set, only a few with bit 32.
>>
>> I'll switch it back to 0xe0.
>
> Fwiw, for the purpose of that function you might as well write:
>
> static inline int amd_is_nb_event(struct hw_perf_event *hwc)
> {
>        return (hwc->config & K7_EVNTSEL_EVENT_MASK) > 0xe0;
> }
>
> No need to move bits around higher than the value you compare against.
>
I think given the existing event codes, that would be fine too.
