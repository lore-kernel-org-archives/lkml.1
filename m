Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab0BPSoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:44:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756468Ab0BPSoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:44:00 -0500
Date: Tue, 16 Feb 2010 10:43:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: set_personality_ia32() abuses TS_COMPAT
In-Reply-To: <20100216174437.GA28323@redhat.com>
Message-ID: <alpine.LFD.2.00.1002161041130.4141@localhost.localdomain>
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org> <20100216140126.GA16448@redhat.com>
 <20100216140242.GC16448@redhat.com> <alpine.LFD.2.00.1002160738530.18830@localhost.localdomain> <20100216174437.GA28323@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Feb 2010, Oleg Nesterov wrote:
> 
> and, following this logic, shouldn't set_personality_64bit() clear
> TS_COMPAT ?

Yes, I think it should. If we come from a 32-bit environment, and execute 
a 64-bit binary, I think the execve() environment of the new 64-bit binary 
should be _exactly_ the same as if it was executed from a 64-bit one.

Of course, it's entirely possible that TS_COMPAT simply doesn't matter at 
all in either context, but I do think that we should strive for "the 
binary does exactly the same regardless of whether it was started from 
a 32-bit or a 64-bit binary".

And the best way to guarantee that is to make sure that we really do set 
the environment to the same thing. So yes, set_personality_64bit() should 
clear all the 32-bit compat bits.

		Linus
