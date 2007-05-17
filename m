Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbXEQBL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbXEQBL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbXEQBLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:11:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762733AbXEQBLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:11:50 -0400
Date: Wed, 16 May 2007 18:10:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian <haveaniceday@cv-sv.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
In-Reply-To: <464B9D2C.7040704@cv-sv.de>
Message-ID: <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org>
References: <464B9D2C.7040704@cv-sv.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 May 2007, Christian wrote:
>
> my small VIA C3_2 box does not boot with 2.6.22-rc1.
> It even does not uncompress the kernel.
> 
> The configuration as M386 M486 works. But M586 + MVIAC3_2
> does not work.

Ahh, from the EPIA HOWTO:

	13.2. Is the C3 Pentium compatible?

	Yes. But Samuel 2, Ezra, Ezra T C3 processors have a problem with 
	the cmpxchg8b (i.e. CMOV) opcode. Nehemiah and Antaur processors 
	are not affected.

However, that would imply that you don't have a VIA C3-2 (Nehamiah) at 
all, but the older original CyrixIII/VIA C3.

Can you check? The Nehemian (C3-2) should be model 9 or greater.

So afaik, you should use MCYRIXIII, and make _that_ be the one that 
disables the use of the cmpxchg8b instruction.

Can you please verify?

		Linus
