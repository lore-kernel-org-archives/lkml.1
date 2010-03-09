Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0CIBlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:41:14 -0500
Received: from smtp-out.google.com ([216.239.33.17]:50758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab0CIBlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:41:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=x7Jx4Qpd3YV7Ckt1/J72D2wn0ZWFYHpB5iQlqiZKWmqPNyhh8KAS4SNRnycoLNxfu
	13Gom5/LfUa6euioaenSg==
MIME-Version: 1.0
In-Reply-To: <1267693046.25158.143.camel@laptop>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.602529559@chello.nl> <4B8EA4D9.6000505@redhat.com>
	 <1267645029.25158.106.camel@laptop> <4B8ED097.6090006@redhat.com>
	 <bd4cb8901003031350v274ca388v48ad61d7baa87d90@mail.gmail.com>
	 <1267693046.25158.143.camel@laptop>
Date: Tue, 9 Mar 2010 02:41:03 +0100
Message-ID: <bd4cb8901003081741n5164140flc0999dc01e290c3@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/11] perf, x86: use LBR for PEBS IP+1 fixup
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, robert.richter@amd.com,
       fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 9:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-03-03 at 22:50 +0100, Stephane Eranian wrote:
>
>> I think systematically and transparently using LBR to correct PEBS off-by-one
>> problem is not such a good idea. You've basically highjacked LBR and user
>> cannot use it in a different way.
>
> Well, they could, it just makes scheduling the stuff more interesting.
>
>> There are PEBS+LBR measurements where you care about extracting the LBR data.
>> There are PEBS measurements where you don't care about getting the correct IP.
>> I don't necessarily want to pay the price, especially when this could
>> be done offline in the tool.
>
> There are some people who argue that fixing up that +1 insn issue is
> critical, sadly they don't appear to want to argue their case in public.
> What we can do is make it optional I guess.

I can see why they would want IP, instead of IP+1. But what I am saying
is that there are certain measurements where you need to use LBR in
another way. For instance, you may want to combine PEBS + LBR to capture the
path that leads to a cache miss. For that you would need to configure LBR
to record only call branches. Then you would do the correction of the IP offline
in the tool. In this case, the patch is more important than the IP+1 error.

This is why I think you need to provide a config field to disable IP+1
correction,
and thus free LBR for other usage. I understand this also means you cannot
share the LBR with other competing events (on the same or distinct CPUs),
but that's what event scheduling is good for.
