Return-Path: <linux-kernel-owner+w=401wt.eu-S933138AbYBUQC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbYBUQC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbYBUP65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:58:57 -0500
Received: from colin.muc.de ([193.149.48.1]:4235 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933663AbYBUP6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:58:55 -0500
Date: 21 Feb 2008 16:58:52 +0100
Date: Thu, 21 Feb 2008 16:58:52 +0100
From: Andi Kleen <ak@muc.de>
To: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
Message-ID: <20080221155852.GA42442@muc.de>
References: <kjm4pc3d92p.fsf@pelargir.dolphinics.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kjm4pc3d92p.fsf@pelargir.dolphinics.no>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 02:57:34PM +0100, Arne Georg Gleditsch wrote:
> Hi,
> 
> I'm looking at 2.6.25-rc2.  vsyscall_sysctl_change contains code to NOP
> out the actual system call instructions of the vsyscall page when
> vsyscall64 is enabled.  This seems to interact badly with the fallback
> code in do_vgettimeofday which tries to call gettimeofday if the
> configured clock source does not support vread.  (In effect,
> gettimeofday() becomes a nop and time() always returns 0.  Not very
> useful.)
> 
> Is there a good reason to keep this?  Aren't the instructions in
> question avoided (or invoked) according to the vsyscall64 flag by the
> surrounding logic anyway?

Yes they are.  But a system call sequence at a known fixed address
is potentially useful to exploits. That is why it is nop'ed out when
it is not needed.

-Andi
