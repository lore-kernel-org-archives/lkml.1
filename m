Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZCNIOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZCNIOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZCNIOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:14:08 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:57857 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZCNIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:14:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rFqTpHo3XT26+Y0gaUyNQmszQozmmQDoZbls9XiMhFciCNcAvRr2pZ8RTYeU0/jDcv
         mQhoDUl1Fb6Nsz+3Y+PBXC6nFSE8X4rR3fDyuAkko8OcKXH7c1Bos7tqt7JqtqbBM6Tt
         cg5eu3AkgCDzYSOW254N2Bf+t3B7V6ibXmn8c=
Date: Sat, 14 Mar 2009 11:13:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, fweisbec@gmail.com,
       hpa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/syscalls] x86: entry_32.S fix compile warnings -
	fix work mask bit width
Message-ID: <20090314081359.GA7405@localhost>
References: <1237012693.18733.3.camel@ht.satnam> <tip-95baa1a17ff80183317d815189fe1f12fdb653bc@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-95baa1a17ff80183317d815189fe1f12fdb653bc@git.kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jaswinder Singh Rajput - Sat, Mar 14, 2009 at 07:18:32AM +0000]
| Commit-ID:  95baa1a17ff80183317d815189fe1f12fdb653bc
| Gitweb:     http://git.kernel.org/tip/95baa1a17ff80183317d815189fe1f12fdb653bc
| Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
| AuthorDate: Sat, 14 Mar 2009 12:08:13 +0530
| Commit:     Ingo Molnar <mingo@elte.hu>
| CommitDate: Sat, 14 Mar 2009 08:16:01 +0100
| 
| x86: entry_32.S fix compile warnings - fix work mask bit width
| 
| Fix:
| 
|  arch/x86/kernel/entry_32.S:446: Warning: 00000000080001d1 shortened to 00000000000001d1
|  arch/x86/kernel/entry_32.S:457: Warning: 000000000800feff shortened to 000000000000feff
|  arch/x86/kernel/entry_32.S:527: Warning: 00000000080001d1 shortened to 00000000000001d1
|  arch/x86/kernel/entry_32.S:541: Warning: 000000000800feff shortened to 000000000000feff
|  arch/x86/kernel/entry_32.S:676: Warning: 0000000008000091 shortened to 0000000000000091
| 
| TIF_SYSCALL_FTRACE is 0x08000000 and until now we checked the
| first 16 bits of the work mask - bit 27 falls outside of that.
| 
| Update the entry_32.S code to check the full 32-bit mask.
| 
| Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
| Cc: Frederic Weisbecker <fweisbec@gmail.com>
| Cc: Steven Rostedt <rostedt@goodmis.org>
| Cc: "H. Peter Anvin" <hpa@kernel.org>
| LKML-Reference: <1237012693.18733.3.camel@ht.satnam>
| Signed-off-by: Ingo Molnar <mingo@elte.hu>
| 
| 
| ---
|  arch/x86/kernel/entry_32.S |   18 ++++++++----------
|  1 files changed, 8 insertions(+), 10 deletions(-)
| 
...  
|  sysexit_audit:
| -	testw $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
| +	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
							^^^^^
Better to point ecx here? :)

	- Cyrill -
