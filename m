Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbZFOThG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbZFOThG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZFOTg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:36:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZFOTgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:36:55 -0400
Message-ID: <4A36A1C7.6080005@zytor.com>
Date: Mon, 15 Jun 2009 12:32:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, efault@gmx.de, jeremy@goop.org,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop> <4A369CD8.3090505@zytor.com> <20090615192720.GA9056@Krystal>
In-Reply-To: <20090615192720.GA9056@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
>>>
>> Writing control registers is serializing, so it's a lot more expensive
>> than writing a normal register; my *guess* is that it will be on the
>> order of 100-200 cycles.
>>
>> That is not based on any actual information.
>>
> 
> Then how about just writing to the cr2 register *if* it has changed
> while the NMI handler was running ?
> 
> if (unlikely(read_cr2() != saved_cr2)))
> 	write_cr2(saved_cr2)
> 
> Mathieu
> 

That works fine, obviously, and although it's probably overkill it's
also a trivially cheap optimization.

	-hpa

