Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbXISRay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbXISRay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbXISRai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:30:38 -0400
Received: from gw.goop.org ([64.81.55.164]:55790 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324AbXISRah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:30:37 -0400
Message-ID: <46F15CB8.6010408@goop.org>
Date: Wed, 19 Sep 2007 10:30:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org> <20070919130122.GA21750@Krystal> <46F14A58.60904@zytor.com>
In-Reply-To: <46F14A58.60904@zytor.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mathieu Desnoyers wrote:
>   
>> Ok, let's have a good look at what we want:
>>
>> 1 - get a pointer to the beginning of the immediate value within the
>>     instruction.
>> 2 - make sure that the immediate value, within the instruction, is
>>     written to atomically wrt all CPUs, even on older architectures
>>     where non aligned writes are not atomic.
>>
>>     
>
> I think you'll find that even on modern architectures cross-cacheline
> writes aren't atomic.
>   

Cross-cache-line, sure.  But what about just not sizeof aligned?  If its
enough to avoid cross-cache-line, then that's simpler.

Which is something I was going to comment on: Mathieu, you try to align
the constant itself, but you don't prevent the instruction overall from
crossing a cache line.  Given how delicate all this stuff is, it seems
like a good idea to do that.


>> * 4 bytes
>> B8 + rd         MOV r32, imm32   (1 byte opcode)
>> C7 /0           MOV r/m32, imm32 (2 bytes opcode)
>> (the 2 bytes opcode can be a problem)
>>
>>     
>
> If gas generates the C7 opcodes by default, then that's a bug, nothing less.
>   

Well, in this case, it might be preferred if it brings the constant into
alignment without explicit padding :)

    J
