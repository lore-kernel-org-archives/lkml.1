Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbYHGXJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbYHGXJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYHGXJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:09:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbYHGXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:09:40 -0400
Date: Thu, 7 Aug 2008 16:08:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@kernel.org>
cc: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
In-Reply-To: <489B7DFE.5010402@kernel.org>
Message-ID: <alpine.LFD.1.10.0808071603330.3462@nehalem.linux-foundation.org>
References: <1218136365.23770.52.camel@alok-dev1>  <489B6710.9000604@kernel.org>  <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>  <489B6A5C.8030400@kernel.org>  <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>  <489B6E83.7000202@kernel.org>
 <1218146154.20178.352.camel@bodhitayantram.eng.vmware.com> <489B7470.5030408@kernel.org> <alpine.LFD.1.10.0808071533100.3462@nehalem.linux-foundation.org> <489B7DFE.5010402@kernel.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Aug 2008, H. Peter Anvin wrote:
> 
> Just moving it down by 4 MB doesn't help, since the VMI guys want as much as
> 64 MB, which is half the standard vmalloc area and hence too much address
> space lost.  We can't put it at the bottom of the vmalloc area, since that
> boundary is not fixed, either.

Yeah, ok. Since this is a 32-bit only issue, 64MB is actually a fair chunk 
of our already limited virtual space.

> The one remaining fixed boundary in the machine is the kernel-userspace
> boundary.  Hence moving the 1:1 area up by one PDE unit and sticking the
> fixmap area in that region.

Yeah, ok, but I'd be more nervous about the validation issues there. There 
might be a lot of code that assumes that TASK_SIZE is the start of the 1:1 
area. It does sound like a good approach, it just makes me worry about the 
test coverage.

		Linus
