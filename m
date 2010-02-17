Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0BQRjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:39:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab0BQRjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:39:15 -0500
Message-ID: <4B7C29C1.10906@suse.cz>
Date: Wed, 17 Feb 2010 18:39:13 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <20100208092845.GB12618@a1.tnic> <4B6FDAED.9060204@zytor.com> <20100208095945.GA14740@a1.tnic> <20100211172424.GB19779@aftab> <4B743F7D.3090605@zytor.com> <20100212170649.GC3114@aftab> <4B758FC0.1020600@zytor.com> <20100212174751.GD3114@aftab> <4B75A66A.70005@zytor.com> <4B7BF5D6.3030701@suse.cz> <20100217172040.GC13429@aftab> <4B7C27D8.9050408@suse.cz>
In-Reply-To: <4B7C27D8.9050408@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.2.2010 18:31, Michal Marek wrote:
> On 17.2.2010 18:20, Borislav Petkov wrote:
>> On Wed, Feb 17, 2010 at 02:57:42PM +0100, Michal Marek wrote:
>>> On 12.2.2010 20:05, H. Peter Anvin wrote:
>>>> On 02/12/2010 09:47 AM, Borislav Petkov wrote:
>>>>>
>>>>> However, this is generic code and for the above to work we have to
>>>>> enforce x86-specific CFLAGS for it. What is the preferred way to do
>>>>> that?
>>>>>
>>>>
>>>> That's a question for Michal and the kbuild list.  Michal?
>>>
>>> (I was offline last week).
>>>
>>> The _preferred_ way probably is not to do it :), but otherwise you can
>>> set CFLAGS_hweight.o depending on CONFIG_X86(_32|_64), just like you do
>>> in arch/x86/lib/Makefile already.
>>
>> Wouldn't it be better if we had something like ARCH_CFLAGS_hweight.o
>> which gets set in the arch Makefile instead?
> 
> We could, but is it worth it if there is only one potential user so far?
> IMO just put the condition to lib/Makefile now and if there turn out to
> be more cases like this, we can add support for ARCH_CFLAGS_foo.o then.

It wouldn't work actually, because such variable would then apply to all
hweight.o targets in the tree. But another way would be:

arch/x86/Kconfig
config ARCH_HWEIGHT_CFLAGS
        string
        default "..." if X86_32
        default "..." if X86_64

lib/Makefile
CFLAGS_hweight.o = $(CONFIG_ARCH_HWEIGHT_CFLAGS)

Michal
