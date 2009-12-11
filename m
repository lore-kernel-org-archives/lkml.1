Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbZLKLIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbZLKLIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762281AbZLKLIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:08:35 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:43300 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762260AbZLKLIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bvr4styCDYA8Y1OQR3Oc2RwM59HFBKPuBoq+lV4po6FXwtZKlj4eoP83f0rLPxlQkm
         C71JFF4zIwB55WtEF9nvEUBrRSDO8tTPIFSEu9Oga/DkP1nWxxY+yY/Z6ocEWjsOmQA6
         9CZ+R3NQEzUHiqmfd4RSb0716+/ySlOmB3KYE=
MIME-Version: 1.0
In-Reply-To: <20091211110225.GA20831@elte.hu>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
	 <20091211102316.GB16882@elte.hu>
	 <20091211103030.GC4164@wear.picochip.com>
	 <20091211110225.GA20831@elte.hu>
Date: Fri, 11 Dec 2009 13:08:38 +0200
X-Google-Sender-Auth: 8793f7f7519ca6a1
Message-ID: <84144f020912110308m6c8a7acr6b5fdc3f674816f3@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Will Deacon <will.deacon@arm.com>, Jamie Iles <jamie.iles@picochip.com>,
       linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 1:02 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Will Deacon <will.deacon@arm.com> wrote:
>
>> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org]
>> > On Behalf Of Jamie Iles
>> > Sent: 11 December 2009 10:31
>> >
>> > The implementation of the barriers depend on the CPU arch revision
>> > which is defined in the kernel config. As the perf tools don't use
>> > the kernel config, we don't know here what arch revision we're
>> > building for. Perhaps we need a LINUX_ARM_ARCH parameter when
>> > building for ARM so we can pick the correct one.
>>
>> Hi Jamie, Ingo,
>>
>> Surely a better way to proceed with this would be to build the perf
>> tool as a side effect of building the kernel? That way the relevant
>> definitions from system.h could be included directly and there would
>> be no need to duplicate the architectural conditionals in perf.h.
>
> Might make sense.
>
>> I'm also working on perf-events for ARM and am using:
>>
>> #define rmb()           asm volatile("mcr p15, 0, %0, c7, c10, 5" :: "r" (0) : "memory")
>>
>> This will work on v6 and v7 [although the dmb instruction is preferred
>> here] cores.
>
> Note that the codepath where it's used isnt very performance sensitive
> (we call it about once per batch of event processing), so we could use
> the broadest instruction that works on as many cores as possible - to
> keep things simple.

How plausible is it to reuse the bits in
arch/arm/include/asm/cputype.h and do an version of rmb() that has
if-else for the v6 and v7 cases?
