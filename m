Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0CCSSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:18:46 -0500
Received: from smtp-out.google.com ([216.239.33.17]:31469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab0CCSSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:18:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ORHXjHBdxtUQ73QEEnkIg/f+uhkS9i2grmlE8hGUu2em6E3tAdwJuZul5QETQOt4p
	TuRRs2BaxFni11q/ONijA==
MIME-Version: 1.0
In-Reply-To: <20100303.095553.105186917.davem@davemloft.net>
References: <bd4cb8901003030930q4050d074k11a45c3583b96502@mail.gmail.com>
	 <1267637995.25158.96.camel@laptop>
	 <bd4cb8901003030949v3db2db41o9cc1a65d53c370@mail.gmail.com>
	 <20100303.095553.105186917.davem@davemloft.net>
Date: Wed, 3 Mar 2010 10:18:41 -0800
Message-ID: <bd4cb8901003031018u5924753w23080331e5a15583@mail.gmail.com>
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
From: Stephane Eranian <eranian@google.com>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       paulus@samba.org, robert.richter@amd.com, fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 9:55 AM, David Miller <davem@davemloft.net> wrote:
> From: Stephane Eranian <eranian@google.com>
> Date: Wed, 3 Mar 2010 09:49:33 -0800
>
>> On Wed, Mar 3, 2010 at 9:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> On Wed, 2010-03-03 at 09:30 -0800, Stephane Eranian wrote:
>>>> This assumes struct pt_regs is somehow exported to userland.
>>>> Is that the case?
>>>
>>> I seems to have understood they were, and asm/ptrace.h seems to agree
>>> with that, it has !__KERNEL__ definitions for struct pt_regs.
>>>
>> Seems to be the case, indeed.
>
> BTW, how are you going to cope with compat systems?
>
> If I build 'perf' on a sparc64 kernel build, it's going to get the
> 64-bit pt_regs.  So I can't then use that binary on a sparc box
> running a 32-bit kernel.
>
> And vice versa.
>
That was going to be my next question. The pt_regs you return
depends on the binary you are monitoring (32 vs. 64) if interrupt
occurred in userland. But what about if it happens in kernel mode?


> And more generally aren't we supposed to be able to eventually analyze
> perf dumps on any platform not just the one 'perf' was built under?
>
> We'll need to do something about the encoding of pt_regs, therefore.
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
