Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYHGWjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYHGWjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYHGWjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:39:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYHGWjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:39:40 -0400
Date: Thu, 7 Aug 2008 15:38:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@kernel.org>
cc: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
In-Reply-To: <489B7470.5030408@kernel.org>
Message-ID: <alpine.LFD.1.10.0808071533100.3462@nehalem.linux-foundation.org>
References: <1218136365.23770.52.camel@alok-dev1>  <489B6710.9000604@kernel.org>  <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>  <489B6A5C.8030400@kernel.org>  <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>  <489B6E83.7000202@kernel.org>
 <1218146154.20178.352.camel@bodhitayantram.eng.vmware.com> <489B7470.5030408@kernel.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Aug 2008, H. Peter Anvin wrote:
> 
> The only way I can see around that, though, is to move the 1:1 mapping base up
> by 2/4 MB (for PAE/no PAE, respectively) and put the fixmap area there.  Kind
> of sucks, but would be doable.

So if the address isn't fixed, you'll end up with an indirect pointer, and 
it would likely be much better to just use a fixed direct pointer that is 
not at the top.

And anything that is within the top 31 bits of the address space should 
generate the same good code, since the fixed offset is always going to be 
a 32-bit thing anyway. So moving the FIXMAP area down by 4MB sounds like a 
fine thing to do with no real downside, if it then means that we don't 
need to move the FIXMAP area at all.

Hmm? Am I missing something?

		Linus
