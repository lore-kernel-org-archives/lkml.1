Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYG2XOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYG2XOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYG2XOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:14:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYG2XOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:14:04 -0400
Message-ID: <488FA318.3040905@zytor.com>
Date: Tue, 29 Jul 2008 16:09:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, roland@redhat.com,
       drepper@redhat.com, mikpe@it.uu.se, chrisw@sous-sol.org,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
References: <20080729172917.185593000@linux-os.sc.intel.com>
In-Reply-To: <20080729172917.185593000@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> This patchset adds the support for xsave/xrstor infrastructure for x86.
> xsave/xrstor manages the existing and future processor extended states in x86
> architecutre.
> 
> More info on xsave/xrstor can be found in the Intel SDM's located at
> http://www.intel.com/products/processor/manuals/index.htm
> 
> The layout of the xsave/xrstor area extends from the 512-byte FXSAVE/FXRSTOR
> layout.  xsave/xrstor area layout consists of:
> 
>      - fxsave/fxrstor area (512 bytes)
>      - xsave header area (64 bytes)
>      - set of save areas, each corresponding to a processor extended state
> 
> The number of save areas, the offset and the size of each save area is
> enumerated by CPUID leaf function 0xd. 
> 
> This patch includes the basic xsave/xrstor infrastructure(supporting FP/SSE),
> which includes:
>       - context switch support,  extending traditional lazy restore mechanism
>       - signal handling support, extending(using the software reserved bytes
> 	464..511 in the current 512byte layout of fxsave frame) the memory
> 	layout pointed out by the fpstate pointer in the sigcontext
> 
> More details in the patches to follow.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Applied as tip:x86/xsave.

I should warn I had to do quite a bit of manual fixup in order to 
disentangle it from other changes in -tip, so please test it out; I 
compile-tested it but for obvious reasons can't do more than that at the 
moment.

	-hpa
