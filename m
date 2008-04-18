Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbYDRRv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbYDRRv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 13:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758817AbYDRRvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 13:51:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:21967 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbYDRRvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 13:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=CcDbAAcq877GB2EpmKKY9flslBpe6DNBUigkiiwAj1AYnIsqV8njiEJxmfAoyxFkZFBc1/DRucotiwSEXB2Pl3rgmqJ9JqWTrq8MaYy46UJ6/mla7NOioCxXkNGD6udBZsPxfkCcilPkx0jNqWIuPKgYxd1Ar2rBwoysd9FuqCk=
Date: Fri, 18 Apr 2008 21:51:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kgdb build fix
Message-ID: <20080418175104.GD7674@cvg>
References: <1208537678.17196.40.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208537678.17196.40.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Harvey Harrison - Fri, Apr 18, 2008 at 09:54:38AM -0700]
| TF_MASK is no longer defined, use X86_EFLAGS_TF.
| 
| Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
| ---
| In current -linus tree.
| 
|  arch/x86/kernel/kgdb.c |    4 ++--
|  1 files changed, 2 insertions(+), 2 deletions(-)
| 
| diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
| index 8c7e555..24362ec 100644
| --- a/arch/x86/kernel/kgdb.c
| +++ b/arch/x86/kernel/kgdb.c
| @@ -375,12 +375,12 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
|  		newPC = linux_regs->ip;
|  
|  		/* clear the trace bit */
| -		linux_regs->flags &= ~TF_MASK;
| +		linux_regs->flags &= ~X86_EFLAGS_TF;
|  		atomic_set(&kgdb_cpu_doing_single_step, -1);
|  
|  		/* set the trace bit if we're stepping */
|  		if (remcomInBuffer[0] == 's') {
| -			linux_regs->flags |= TF_MASK;
| +			linux_regs->flags |= X86_EFLAGS_TF;
|  			kgdb_single_step = 1;
|  			if (kgdb_contthread) {
|  				atomic_set(&kgdb_cpu_doing_single_step,
| -- 
| 1.5.5.144.g3e42
| 
It seems to be my fault, thanks a lot Harvey!

		- Cyrill -
