Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbZLKOwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbZLKOwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbZLKOwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:52:44 -0500
Received: from 216-239-44-51.google.com ([216.239.44.51]:2951 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbZLKOwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:52:43 -0500
X-Greylist: delayed 836 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2009 09:52:43 EST
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=smljZL+RpHAYluOwLYWhGMI+CvByaqA9FVotxDdl2QNyKXjSh1XAWknSAnhTnhEtV
	ntr6OlmYQbFhUtbXewkgg==
MIME-Version: 1.0
In-Reply-To: <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
	 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
Date: Fri, 11 Dec 2009 15:38:52 +0100
Message-ID: <bd4cb8900912110638h4711587v31cd47a85565b9d7@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
From: Stephane Eranian <eranian@google.com>
To: eranian@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, perfmon2-devel@lists.sf.net,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:00 PM, stephane eranian
<eranian@googlemail.com> wrote:
>>> --- a/arch/x86/kernel/cpu/perf_event.c
>>> +++ b/arch/x86/kernel/cpu/perf_event.c
>>
>>> @@ -68,6 +69,15 @@ struct debug_store {
>>>       u64     pebs_event_reset[MAX_PEBS_EVENTS];
>>>  };
>>>
>>> +#define BITS_TO_U64(nr) DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
>>
>> Do we need this, is it realistic to expect X86_PMC_IDX_MAX to be
>> anything else than 64?
>>
> The issue had to do with i386 mode where long are 32 bits  < 64. And in
> particular with the initializer .idxmsk[0] = V. In the future we may exceed
> 32 registers. That means the initializer would have to change. But I guess
> we have quite some ways before this case is reached. So I will revert all
> of this to unsigned long.
>
Well, in fact we have to use u64 because you are already using register
indexes > 32, e.g., for the Intel fixed counters which start at position 32.
Using unsigned long would make the static initializer uglier in this case.
