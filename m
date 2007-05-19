Return-Path: <linux-kernel-owner+w=401wt.eu-S1764322AbXESSWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764322AbXESSWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbXESSWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:22:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:46344 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbXESSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sJ+kvODNziuLMlwvlM1DyLiTem17OhHoKpGR04sdLYEUM5D0qt1wm8CNNtjnnQnAocM+nBugNOtdRsWo1pnhVKrwnoFg5P3dO2YrOeok53zNXfdOcV/a0lK3Ah/GgTg34f2H/VxaD/shec1pxLo62MkzeTjBanVT/cmXreJh2yo=
Message-ID: <787b0d920705191122m5f481d54k363f5f473880a664@mail.gmail.com>
Date: Sat, 19 May 2007 14:22:15 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Cc: tglx@linutronix.de, "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <fa84736ae121902d4bee24eb23ca1d0b@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920705172024g723412b4n8f82d3cd78e0f702@mail.gmail.com>
	 <464DBDBA.3060801@ru.mvista.com>
	 <787b0d920705181845h355eed4fk2bf93323332a9d90@mail.gmail.com>
	 <fa84736ae121902d4bee24eb23ca1d0b@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Segher Boessenkool <segher@kernel.crashing.org> wrote:
> [Albert Cahalan]

> > Set MMCR0[TBEE], set MMCR0[PMXE], and choose a TBL bit via
> > MMCR0[TBSEL].
>
> That's the performance monitor, which could very well be
> in use already (for performance monitoring stuff, who
> would have guessed).

It is the performance monitor, which sadly can not be used
very well unless the decrementer is disabled. The hardware
is buggy. As long as we use the decrementer for timekeeping,
we can not safely generate performance monitor interrupts.

I'd like to have the performance monitor available. It's NOT
available unless we use part of it for timekeeping. That's the
choice the hardware gives us.

We can get TBL bit flip interrupts for free. We don't even need
to give up one of the event counters. If we do give up one of the
event counters (a rather reasonable idea), then we can count
one of those TBL bit flips or the cycle counter.
