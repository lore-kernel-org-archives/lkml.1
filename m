Return-Path: <linux-kernel-owner+w=401wt.eu-S1765984AbZFOSo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765984AbZFOSo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763579AbZFOSoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:44:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZFOSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:44:16 -0400
Message-ID: <4A369573.1060504@zytor.com>
Date: Mon, 15 Jun 2009 11:39:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <20090615182348.GC11248@elte.hu>
In-Reply-To: <20090615182348.GC11248@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
>> Hrm, would it be possible to save the c2 register upon nmi handler 
>> entry and restore it before iret instead ? This would ensure a 
>> nmi-interrupted page fault handler would continue what it was 
>> doing with a non-corrupted cr2 register after returning from nmi.
>>
>> Plus, this involves no modification to the page fault handler fast 
>> path.
> 
> I guess this kind of nesting would work too - assuming the cr2 can 
> be written to robustly.
> 
> And i suspect CPU makers pull off a few tricks to stage the cr2 info 
> away from the page fault entry execution asynchronously, so i'd not 
> be surprised if writing to it uncovered unknown-so-far side-effects 
> in CPU implementations.
> 

I wouldn't actually expect that, *as long as* there is serialization
between the cr2 write and the cr2 read.

	-hpa

