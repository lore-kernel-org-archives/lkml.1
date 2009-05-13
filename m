Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZEMIEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZEMIEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbZEMIDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:03:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49567 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbZEMIDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:03:41 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for /proc/cpuinfo
From: Andi Kleen <andi@firstfloor.org>
References: <1242112482.3283.1.camel@localhost.localdomain>
	<20090512232122.61f2d7c5.akpm@linux-foundation.org>
Date: Wed, 13 May 2009 10:03:39 +0200
In-Reply-To: <20090512232122.61f2d7c5.akpm@linux-foundation.org> (Andrew Morton's message of "Tue, 12 May 2009 23:21:22 -0700")
Message-ID: <878wl1mntw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 12 May 2009 12:44:42 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
>
>> +		   "ext cpuid level\t: 0x%x\n"
>
> It's unobvious what "ext" means.  External?
>
> Can we make it "extended cpuid level"?
>
> One would hope that google(extended cpuid level) tells you what an
> extended cpuid level is, but alas, unclear.

AMD has an own cpuid range in 0x8000_0000+. But it's only useful
if you actually access it using cpuid. Everyone who needs it 
already needs to call cpuid and if they do that they 
can as well retrieve it by themselves.

Without accessing CPUID it has no value at whatsoever. It would
also seem pretty dumb to spend a few thousand cycles getting
it from the kernel when you can as well get it directly
from CPUID and you need to have that code anyways.

The useful information in 8000_0000+ is all reported by the kernel 
anyways. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
