Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0CAHf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 02:35:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44738 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab0CAHf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 02:35:56 -0500
Message-ID: <4B8B6E43.9030305@zytor.com>
Date: Sun, 28 Feb 2010 23:35:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>, Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86-32: improve atomic64_t functions (v2)
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>	 <4B845AEE.5080604@zytor.com>	 <ff13bc9a1002240156x27e28764mb6ba24da0b125d81@mail.gmail.com>	 <20100226101423.GA25641@elte.hu>	 <ff13bc9a1002260308k319d34b5y4757fcfb36106278@mail.gmail.com> <ff13bc9a1002260323k6b3f38ah4f0505e401dcf77d@mail.gmail.com>
In-Reply-To: <ff13bc9a1002260323k6b3f38ah4f0505e401dcf77d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2010 03:23 AM, Luca Barbieri wrote:
> Sent patches, both to conditionally perform the test and implement the
> functions for x86 and x86-64.

Yes, and with the test turned on, the kernel crashes immediately on boot
on x86-64.

Some minor investigation reveals the following:

lib/atomic64.c has the wrong return value for atomic64_add_unless().
With "wrong" I mean it is the opposite sense compared to
atomic_add_unless(), not just on x86 but on all architectures.

Accordingly, I have to conclude that lib/atomic64.c is buggy, and that
since your test matches that bug, I will have to conclude that your
x86-32 implementation is also buggy.  Thus, please send patches to fix
your test and your 32-bit implementations (and preferrably
lib/atomic64.c too, but I can do that just fine.)

Cc: Paul Mackerras who did the generic atomic64_t implementation for
verification that this is indeed a bug.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

