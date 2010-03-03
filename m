Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0CCRtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:49:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:17719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab0CCRti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:49:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=SpF5+WoF6QHVuK0U5RBzsEMKTSVVTs7Fn4iOdqZ9EzJfKozvZMtefW/+f2O7fV7gC
	6+SgXJpn6jWxOCjt+uiPA==
MIME-Version: 1.0
In-Reply-To: <1267637995.25158.96.camel@laptop>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.375353163@chello.nl>
	 <bd4cb8901003030930q4050d074k11a45c3583b96502@mail.gmail.com>
	 <1267637995.25158.96.camel@laptop>
Date: Wed, 3 Mar 2010 09:49:33 -0800
Message-ID: <bd4cb8901003030949v3db2db41o9cc1a65d53c370@mail.gmail.com>
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 9:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-03-03 at 09:30 -0800, Stephane Eranian wrote:
>> This assumes struct pt_regs is somehow exported to userland.
>> Is that the case?
>
> I seems to have understood they were, and asm/ptrace.h seems to agree
> with that, it has !__KERNEL__ definitions for struct pt_regs.
>
Seems to be the case, indeed.

>> I would clearly spell out that the REGS are the interrupted REGS,
>> not the overflow REGS. Maybe PERF_SAMPLE_IREGS.
>
> They can be both, for PEBS they are the overflow trap (until PEBS does
> fault) regs.

You're saying without PEBS= interrupted state, with PEBS=overflow state.
That precludes requesting both interrupted + overflow state when PEBS is
enabled. That may be interesting to look at differences, distances (in the IP).
