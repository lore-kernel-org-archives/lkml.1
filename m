Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbYEWBeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbYEWBeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYEWBeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:34:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYEWBeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:34:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: Suresh Siddha's message of  Thursday, 22 May 2008 17:42:06 -0700 <20080523004206.GD7998@linux-os.sc.intel.com>
References: <18482.53246.642835.894623@harpo.it.uu.se>
	<4832E705.2010900@zytor.com>
	<18482.60491.764019.292031@harpo.it.uu.se>
	<20080520175325.GE30034@linux-os.sc.intel.com>
	<4834BE39.2000904@zytor.com>
	<18485.13663.51624.694435@harpo.it.uu.se>
	<20080522205619.GB7998@linux-os.sc.intel.com>
	<4835DF64.6080104@zytor.com>
	<18485.62848.335125.152538@harpo.it.uu.se>
	<483610DA.7010606@zytor.com>
	<20080523004206.GD7998@linux-os.sc.intel.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080523013353.7FBB026FA24@magilla.localdomain>
Date: Thu, 22 May 2008 18:33:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I was doing in the RFC is: restore the state what ever that was
> present and init the state that was not present in the stack frame.

That is consistent in spirit with the existing treatment of FPU data.
That is, if the sigcontext.fpstate pointer is NULL, the thread's FPU
state is reset to default.  (And despite what hpa said about being
"supported", the facts in the code are that sigreturn just follows the
sigcontext.fpstate pointer, whatever it is.  On 32-bit, the pointer is
NULL in the context saved when the thread had not used the FPU, so
modifying the sigcontext to include FP state when it didn't before
requires putting in some user-chosen pointer.  There in fact may well be
existing code that does user-level coroutine switching using sigreturn
and relies on this, for all we know.)


Thanks,
Roland
