Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbZFXQsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbZFXQsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760790AbZFXQrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:47:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758772AbZFXQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:47:54 -0400
Date: Wed, 24 Jun 2009 09:46:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH V2] futex: Fix the write access fault problem for real
In-Reply-To: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906240946000.3240@localhost.localdomain>
References: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Thomas Gleixner wrote:
> 
> The solution is to not rely on access_ok and get_user() for any write
> access related fault on private and shared futexes. Instead we need to
> fault it in with verification of write access.
> 
> There is no generic non destructive write mechanism which would fault
> the user page in trough a #PF, but as we already know that we will
> fault we can as well call get_user_pages() directly and avoid the #PF
> overhead.

Ack. Patch looks saner this way, and the commit message explains the 
issues.

		Linus
