Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0BVUlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:41:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45011 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0BVUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:41:00 -0500
Message-ID: <4B82E144.1050007@zytor.com>
Date: Mon, 22 Feb 2010 11:55:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
References: <20100217172040.GC13429@aftab> <4B7C27D8.9050408@suse.cz> <4B7C29C1.10906@suse.cz> <20100218061923.GA1594@liondog.tnic> <20100219142205.GA32533@aftab> <4B7EB6EF.9010405@zytor.com> <20100219164512.GA492@aftab> <4B7EC20C.30607@zytor.com> <20100222141737.GB21233@aftab> <4B82BD01.3030008@zytor.com> <20100222184945.GD21233@aftab>
In-Reply-To: <20100222184945.GD21233@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 10:49 AM, Borislav Petkov wrote:
>>
>> Just a note: this still means rdi is clobbered on x86-64, which is
>> probably fine, but needs to be recorded as such.  Since gcc doesn't
>> support clobbers for registers used as operands (sigh), you have to
>> create a dummy output and assign it a "=D" constraint.
>>
>> I don't know if gcc would handle -fcall-saved-rdi here... and if so, how
>> reliably.
> 
> Ok, from looking at kernel/sched.s output it looks like it saves rdi
> content over the alternative where needed. I'll do some more testing
> just to make sure.
> 

No, you can't rely on behavioral observation.  A different version of
gcc could behave differently.  We need to make sure we tell gcc what the
requirements actually are, as opposed to thinking we can just fix them.

+#define POPCNT ".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t.byte
0xb8\n\t.byte 0xc7"

BTW, this can be written:

#define POPCNT ".byte 0xf3,0x48,0x0f,0xb8,0xc7"

	-hpa
