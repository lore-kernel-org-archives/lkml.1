Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0CDRyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:54:10 -0500
Received: from smtp-out.google.com ([216.239.44.51]:1846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0CDRyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:54:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=wn8sV0vd+nwXULCkiQame9Lg/kOhw+/zVKEihzusouCn6aQnVMO7C0Dn4byGwAk1J
	e3G93tRbE80xkZoWEAbMQ==
MIME-Version: 1.0
In-Reply-To: <1267693107.25158.149.camel@laptop>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.451251096@chello.nl>
	 <bd4cb8901003031357x9c13c96h3899ab0459a34b0e@mail.gmail.com>
	 <1267693107.25158.149.camel@laptop>
Date: Thu, 4 Mar 2010 09:54:04 -0800
Message-ID: <bd4cb8901003040954n5b05e139wa24f8e50789421ac@mail.gmail.com>
Subject: Re: [RFC][PATCH 08/11] perf, x86: Implement simple LBR support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 12:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-03-03 at 22:57 +0100, Stephane Eranian wrote:
>> I don't understand how LBR state is migrated when a per-thread event is moved
>> from one CPU to another. It seems LBR is managed per-cpu.
>>
>> Can you explain this to me?
>
> It is not, its basically impossible to do given that the TOS doesn't
> count more bits than is strictly needed.
>
I don't get that about the TOS.

So you are saying that one context switch out, you drop the current
content of LBR. When you are scheduled back in on an another CPU,
you grab whatever is there?

> Or we should stop supporting cpu and task users at the same time.
>
Or you should consider LBR as an event which has a constraint that
it can only run on one pseudo counter (similar to what you do with
BTS). Scheduling would take care of the mutual exclusion. Multiplexing
would provide the work-around.
