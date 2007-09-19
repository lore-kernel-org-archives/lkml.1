Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbXISQQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbXISQQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760625AbXISQQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:16:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49813 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724AbXISQQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:16:19 -0400
Message-ID: <46F14A58.60904@zytor.com>
Date: Wed, 19 Sep 2007 09:12:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org> <20070919130122.GA21750@Krystal>
In-Reply-To: <20070919130122.GA21750@Krystal>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Ok, let's have a good look at what we want:
> 
> 1 - get a pointer to the beginning of the immediate value within the
>     instruction.
> 2 - make sure that the immediate value, within the instruction, is
>     written to atomically wrt all CPUs, even on older architectures
>     where non aligned writes are not atomic.
> 

I think you'll find that even on modern architectures cross-cacheline
writes aren't atomic.

Anyway, disregard the bit I mentioned about one byte longer; I've been
staring myself too blind at instruction variants lately (lots of
arguments about how to generate various instructions using NASM syntax).

> 
> * 4 bytes
> B8 + rd         MOV r32, imm32   (1 byte opcode)
> C7 /0           MOV r/m32, imm32 (2 bytes opcode)
> (the 2 bytes opcode can be a problem)
> 

If gas generates the C7 opcodes by default, then that's a bug, nothing less.

	-hpa
