Return-Path: <linux-kernel-owner+w=401wt.eu-S1763955AbYBTO0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763955AbYBTO0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYBTO0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:26:24 -0500
Received: from poesci.dolphinics.no ([81.175.23.36]:33465 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbYBTO0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:26:23 -0500
X-Greylist: delayed 1772 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 09:26:23 EST
From: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@muc.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Subject: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
Date: Wed, 20 Feb 2008 14:57:34 +0100
Message-ID: <kjm4pc3d92p.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking at 2.6.25-rc2.  vsyscall_sysctl_change contains code to NOP
out the actual system call instructions of the vsyscall page when
vsyscall64 is enabled.  This seems to interact badly with the fallback
code in do_vgettimeofday which tries to call gettimeofday if the
configured clock source does not support vread.  (In effect,
gettimeofday() becomes a nop and time() always returns 0.  Not very
useful.)

Is there a good reason to keep this?  Aren't the instructions in
question avoided (or invoked) according to the vsyscall64 flag by the
surrounding logic anyway?

-- 
								Arne.
