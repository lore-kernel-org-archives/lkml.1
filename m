Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0CEVWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:22:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:55806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0CEVWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:22:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jmEU8+OanPAA6yOY/SqTWgYlrk5uaPDFuzzeNTtv8q908ma1SXzOOHQN4DK/uQFU6
	cEXSPtxFLVZrbgmHecspg==
MIME-Version: 1.0
In-Reply-To: <1267823134.4997.5.camel@laptop>
References: <20100305153926.639506880@chello.nl>
	 <20100305154128.890278662@chello.nl>
	 <bd4cb8901003051058k5c3d88bewa787f88f03d2da80@mail.gmail.com>
	 <1267816553.4942.6.camel@laptop> <1267823134.4997.5.camel@laptop>
Date: Fri, 5 Mar 2010 13:22:06 -0800
Message-ID: <bd4cb8901003051322l1722fcaaqacf0c913853d384f@mail.gmail.com>
Subject: Re: [PATCH 3/5] perf, x86: Disable PEBS on clowertown chips
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 1:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-03-05 at 20:15 +0100, Peter Zijlstra wrote:
>> On Fri, 2010-03-05 at 10:58 -0800, Stephane Eranian wrote:
>> > >        case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
>> > > +               x86_pmu.quirks = intel_clowertown_quirks;
>> >
>> > That's too coarse grain!
>> > It is more subtle than this. Some of the errata are marked as Plan
>> > fix. They seem to be
>> > fixed in later models. Your looking at the E5xxx series errata but the
>> > E7xxx do not have
>> > the same problems.
>>
>> OK, I'll look at those errata again and try to come up with a stepping
>> test for this errata.
>
> The two serious ones, AJ106 and AJ68 are no fix and are listed as such
> in all errata I can find, including the 7[23]00 series.
>
Not E74xx. I think it would be fine to drop LBR with PEBS as the work-around
to AJ106.

> I checked the 65nm Core2Duo, Xeon 5200 and Xeon 7[23]00 spec updates.
> Going by that it seems the full model 15 family is broken and I'll leave
> the patch as is.

But the E74xx are okay and you are excluding them. Worst case you should
provide an override.
