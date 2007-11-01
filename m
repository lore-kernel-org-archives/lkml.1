Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbXKATNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbXKATNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXKATN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:13:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbXKATN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:13:26 -0400
Message-ID: <472A2523.2030201@zytor.com>
Date: Thu, 01 Nov 2007 12:12:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: Andreas Herrmann3 <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, travis@sgi.com
Subject: Re: [PATCH] x86: show cpuinfo only for online CPUs
References: <20071101170206.GA7820@alberich.amd.com> <472A08F9.8060605@redhat.com> <20071101173543.GB5568@alberich.amd.com> <20071101183537.GD5568@alberich.amd.com> <472A1EA1.3070109@redhat.com>
In-Reply-To: <472A1EA1.3070109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Andreas Herrmann3 escreveu:
>> On Thu, Nov 01, 2007 at 06:35:43PM +0100, Andreas Herrmann3 wrote:
>>> On Thu, Nov 01, 2007 at 03:12:25PM -0200, Glauber de Oliveira Costa wrote:
>>>> So it could even work, but as accident. Unless I'm wrong about it, I'd
>>>> prefer to see an explicit attribution of cpu_index = 0 somewhere for the
>>>> boot cpu.
>>> Hmm, will look at this as well.
>> BTW, isn't it zero initialized anyway?
>> So, no need to explicitely set cpuinfo->cpu_index=0 for the boot cpu.
> 
> Well, it should be, but as far as I know it is not exactly a guarantee
> given by all compilers. So it should be safer to do it explicitly, with
> no prejudice. Unless it's really guaranteed. If it is, yeah, no need.

Any uninitialized field in a static section (.data or .bss) is 
guaranteed to be initialized to zero.  This is guaranteed by the C 
standard.  In the former case, it is the responsibility of the compiler 
and in the latter by the runtime.

The Linux percpu handling creates a .data.percpu section which is then 
replicated into each of the CPU data blocks; thus, percpu data counts as 
static data for this purpose, and initialization is guaranteed.

	-hpa
