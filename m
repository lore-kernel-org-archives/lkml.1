Return-Path: <linux-kernel-owner+w=401wt.eu-S1762391AbYEWCcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762391AbYEWCcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 22:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758109AbYEWCb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 22:31:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028AbYEWCb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 22:31:59 -0400
Message-ID: <48362B87.6010806@zytor.com>
Date: Thu, 22 May 2008 19:27:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <18485.62848.335125.152538@harpo.it.uu.se> <483610DA.7010606@zytor.com> <20080523004206.GD7998@linux-os.sc.intel.com>
In-Reply-To: <20080523004206.GD7998@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
>>>
>>> The kernel needs to accept one(*) of the formats it can produce, which
>>> is not necessarily what it last produced. It's not inconceivable that
>>> user-space will construct sigframes on the fly (to emulate setcontext),
>>> or that it will mangle sigframes (e.g. to map non-rt to rt before 
>>> sigreturn).
>>>
>>> (*) The format is determined by which version of sys_sigreturn the
>>> user invokes.
>>>
>> No.  You CANNOT restore from a frame that doesn't have the full state - 
>> you don't have enough information to do so!
> 
> What I was doing in the RFC is: restore the state what ever that was present and
> init the state that was not present in the stack frame.

Either way, I find it somewhat surprising that the user would invoke a 
different sys_sigreturn especially if using a restorer function (which 
gcc always does.)

I really think I need to understand your application better, 
*especially* in the light of the fact you wouldn't at the moment know 
how even get the size of the frame.

	-hpa
