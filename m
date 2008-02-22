Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbYBVKh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbYBVKh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYBVKhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:37:14 -0500
Received: from poesci.dolphinics.no ([81.175.23.36]:42438 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYBVKhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:37:12 -0500
From: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>
To: Andi Kleen <ak@muc.de>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
References: <kjm4pc3d92p.fsf@pelargir.dolphinics.no>
	<20080221155852.GA42442@muc.de>
Date: Fri, 22 Feb 2008 11:38:03 +0100
In-Reply-To: <20080221155852.GA42442@muc.de> (Andi Kleen's message of "21 Feb
	2008 16:58:52 +0100, Thu, 21 Feb 2008 16:58:52 +0100")
Message-ID: <kjmskzlb7jo.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@muc.de> writes:
> On Wed, Feb 20, 2008 at 02:57:34PM +0100, Arne Georg Gleditsch wrote:
>> Hi,
>> 
>> I'm looking at 2.6.25-rc2.  vsyscall_sysctl_change contains code to NOP
>> out the actual system call instructions of the vsyscall page when
>> vsyscall64 is enabled.  This seems to interact badly with the fallback
>> code in do_vgettimeofday which tries to call gettimeofday if the
>> configured clock source does not support vread.  (In effect,
>> gettimeofday() becomes a nop and time() always returns 0.  Not very
>> useful.)
>> 
>> Is there a good reason to keep this?  Aren't the instructions in
>> question avoided (or invoked) according to the vsyscall64 flag by the
>> surrounding logic anyway?
>
> Yes they are.  But a system call sequence at a known fixed address
> is potentially useful to exploits. That is why it is nop'ed out when
> it is not needed.

Reasonable enough, as long as it can be determined to be not needed.
Still, isn't the __vsyscall_gtod_data structure part of the same page?
Wouldn't that give you access to any 2-byte opcode you want every 64k
seconds?  You'd need to time your attack, of course, but that could be
done prior to actually launching the exploit...

-- 
								Arne.
