Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZCJO1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZCJO1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZCJO0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:26:44 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:40027 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZCJO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h7hLVRBlIXqKQJPO3hPzhBTOTvehTrijyoifogpXtGF831dyAeh+UwzH6xaK2SS+lb
         gCQ7bMZ+CWEchfWBaJxUe3qFeuFrt3C9bgpPMHNmx9hBOpkj7iDTMGVXVHMpivpzg0mj
         j6OnafQKbNsz+fQjoXDiZusWX0TmjWovXiRSw=
Date: Tue, 10 Mar 2009 22:27:10 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@osdl.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML on UML fixed: it did not start
Message-ID: <20090310142710.GF3157@hack>
References: <20090306194921.GA2881@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306194921.GA2881@cs.unibo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 08:49:22PM +0100, Renzo Davoli wrote:
>It is currently impossible to run a user-mode linux machine inside another user-mode 
>linux (UML on UML). It breaks after a few instructions. When it tries to check
>whether SYSEMU is installed (the inner) UML receives an inconsistent result 
>(from the outer UML).
>
>This is the output of a broken attempt:
>$ ./linux mem=256m ubd0=cow
>Locating the bottom of the address space ... 0x0
>Locating the top of the address space ... 0xc0000000
>Core dump limits :
>        soft - 0
>        hard - NONE
>Checking that ptrace can change system call numbers...OK
>Checking ptrace new tags for syscall emulation...unsupported
>Checking syscall emulation patch for ptrace...check_sysemu : expected SIGTRAP, got status = 256
>$
>
>The problem is the following:
>PTRACE_SYSCALL/SINGLESTEP is currently managed inside arch_ptrace for ARCH=um.
>
>PTRACE_SYSEMU/SUSEMU_SINGLESTEP is not captured in arch_ptrace's switch, therefore
>it is erroneously passed back to ptrace_request (in kernel/ptrace).
>
>This simple patch simply forces ptrace to return an error on PTRACE_SYSEMU/SUSEMU_SINGLESTEP
>as it is unsupported on ARCH=um, and fixes the problem.
>
>I posted the same patch one month ago. I just tested it again against the latest kernel.
>
>	renzo
>
>Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>

Cc: Andrew Morton <akpm@osdl.org>

Andrew, would you like to put this patch into -mm? It looks fine for me.

Renzo, I remember you sent some patches about PTRACE_SYSEMU support
for UML some days ago, could you please rebase them against the latest
-git tree and resend?

Thank you very much! Have a nice day!


Yours,
Cong
 
