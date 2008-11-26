Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbYKZULN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbYKZULN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYKZUK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:10:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:50313 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYKZUK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:10:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZUdaQzp97zh7D9QVSwEhQkptZL0p3BfSeQ/fTLuT7kKtpo839sRRHSlKWyuxxix8Rt
         sxYNudTsLYHeYkUV5v9V08odkD4GwUFOBVCPMcJ/iwmVqOldPylAfX1FI4UMX7lpoVHS
         eJCeMQym3QHj7h6T/XXv/Mw0KE3foIankjj+M=
Date: Wed, 26 Nov 2008 23:10:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Message-ID: <20081126201054.GB2624@localhost>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <874p1u45ke.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874p1u45ke.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Wed, Nov 26, 2008 at 09:04:33PM +0100]
| gorcunov@gmail.com writes:
| > --- a/arch/x86/kernel/entry_64.S
| > +++ b/arch/x86/kernel/entry_64.S
| > @@ -379,7 +379,10 @@ ENTRY(ret_from_fork)
| >  	GET_THREAD_INFO(%rcx)
| >  	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
| >  	CFI_REMEMBER_STATE
| > -	jnz rff_trace
| > +	jz rff_action
| > +	movq %rsp,%rdi
| > +	call syscall_trace_leave
| > +	GET_THREAD_INFO(%rcx)
| 
| The uncommon path is supposed to be out of line. I don't think
| the CPU will like that.
| 
| -Andi
| 
| >  rff_action:
| 
| -- 
| ak@linux.intel.com
| 

Aha! Thanks Andi for review.

		- Cyrill -
