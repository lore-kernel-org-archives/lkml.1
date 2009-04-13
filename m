Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZDMQ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZDMQ3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZDMQ3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:29:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbZDMQ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:29:03 -0400
Message-ID: <49E367E8.7080202@zytor.com>
Date: Mon, 13 Apr 2009 09:27:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --	infrastructure
References: <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain> <20090412163356.GA2392@elte.hu> <49E2398A.3050405@redhat.com> <20090413041625.GF11652@elte.hu> <20090413042459.GA6479@elte.hu>
In-Reply-To: <20090413042459.GA6479@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Yes, we could do memory checks, and ... hey, we already do that:
>>
>>    bb577f9: x86: add periodic corruption check
>>    5394f80: x86: check for and defend against BIOS memory corruption
>>
>> ... and i seem to be the one who implemented it! ;-)
> 
> s/implemented/merged+fixed :-)

Actually, what would probably be more productive than trying to track
corruption would be to drop the low 1 MB of memory before suspend to RAM
- make sure that it is as close to completely unused as possible.

All *known* cases of low memory corruption are either boot time or due
to s2ram.

I don't know how realistic it is to make the low 1 MB completely unused
over the s2ram cycle.  The trivial way of doing it is to simply not use
it -- it's only some 600K after all; a more sophisticated way would be
to explicitly constrain it to transient uses that would be dead at s2ram.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

