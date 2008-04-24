Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbYDXPkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbYDXPkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760127AbYDXPju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:39:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756606AbYDXPjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:39:48 -0400
Date: Thu, 24 Apr 2008 08:39:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
In-Reply-To: <20080424.040239.193699673.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0804240837120.2779@woody.linux-foundation.org>
References: <20080424.040239.193699673.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Apr 2008, David Miller wrote:
> 
> 2) Make use of an unused field in pt_regs to store both
>    a magic number, and the trap number, this allows:
> 
>    a) Removing the funny passing of the "restart_syscall"
>       boolean in the trap return paths to the signal dispatch.
> 
>    b) Allow more accurate stack backtraces, since we have the
>       magic cookie, we can detect trap frames accurately.
> 
>    c) The UTRACE guys want to be able to detect if a thread
>       off the cpu is in a system call, they can do that trivially
>       now just like they can on x86.
> 
>    In fact much of this idea is from Roland McGrath.

Heh. This is what x86 has done since day#1. I wonder why other 
architectures wouldn't have copied that part..

That's "orig_eax". It's a strange name, it really has nothing to do with 
"eax" except for the fact that the system call number comes from that 
register - for traps etc it's a negative value.

			Linus
