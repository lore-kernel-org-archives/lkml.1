Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYGHAir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYGHAir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 20:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYGHAii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 20:38:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754091AbYGHAih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 20:38:37 -0400
Date: Mon, 7 Jul 2008 17:37:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
In-Reply-To: <20080708000233.E8EF3154244@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0807071734540.11076@woody.linux-foundation.org>
References: <20080707065615.77BD9154246@magilla.localdomain> <20080707065742.7C119154246@magilla.localdomain> <alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org> <alpine.LFD.1.10.0807070937520.11076@woody.linux-foundation.org>
 <20080708000233.E8EF3154244@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jul 2008, Roland McGrath wrote:
>
> Is bt slower than testl?

On many microarchitectures, yes. Especially for a memory operand. 

That said, depending on the size of the constant, 'bt' may be _smaller_ 
than testl (8-bit constant vs 32-bit one). Which can make up for it.

> (I used bt there because I saw it used in entry_64.S for all cases
> of testing for only one bit at a time.

I haven't checked recent CPU's, it may not matter much on ones that 
support 64-bit. But bt with a memop was traditionally quite a bit more 
expensive than 'test'. 

I too am too lazy to check. Once it's in the slow-path, it doesn't much 
matter. We're talking a few cycles here.

		Linus
