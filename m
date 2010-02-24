Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0BXCdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:33:39 -0500
Received: from mx1.orcon.net.nz ([219.88.242.51]:47032 "EHLO mx1.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab0BXCdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:33:36 -0500
X-Greylist: delayed 3462 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2010 21:33:36 EST
Message-Id: <1EE1A83F-EB50-40F3-A6A0-5D8DE0B38446@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: HW perf. events arch implementation
Date: Wed, 24 Feb 2010 14:35:04 +1300
Cc: linux-alpha@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx1.orcon.net.nz on Wed, 24 Feb 2010 14:35:52 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Feb 24 14:35:52 2010
X-DSPAM-Confidence: 0.6970
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to implement arch specific code on the Alpha for hardware  
performance events (yeah, I'm probably a little bit loopy and unsound  
of mind pursuing this on an end-of-line platform, but it's a way in to  
learn a little bit of kernel programming and it scratches an itch).

I have taken a look at the code in the x86, sparc and ppc  
implementations and tried to drum up an Alpha implementation for the  
EV67/7/79 cpus, but it ain't working and is producing obviously  
erroneous counts.  Part of the problem is that I don't understand  
under what conditions, and with what assumptions, the performance  
event subsystem is calling into the architecture specific code.  Is  
there any documentation available that describes the architecture  
specific interface?

The Alpha CPUs of interest have two 20-bit performance monitoring  
counters that can count cycles, instructions, Bcache misses and Mbox  
replays (but not all combinations of those).  For round numbers  
consider a 1GHz CPU, with a theoretical maximal sustained throughput  
of four instructions per cycle, then a single performance counter  
could potentially generate 4000 interrupts per second to signal  
counter overflow when counting instructions.

The x86, sparc and PPC implementations seem to me to assume that calls  
to read back the counters occur more frequently than performance  
counter overflow interrupts, and that the highest bit of the counter  
can safely be used to detect overflow.  (Am I correct?)  That is  
likely not to be true of the Alpha because of the small width of the  
counter.  Is there someone who would be happy to give me, a kernel  
newbie who probably doesn't even make the grade of neophyte, a bit of  
direction on this?

Also, the Alpha CPUs have an interesting mode whereby one programmes  
up one counter with a specified (or random) value that specifies a  
future instruction to profile.  The CPU runs for that number of  
instructions/cycles, then a short monitoring window (of a few cycles)  
is opened about the profiled instruction and when completed an  
interrupt is generated.  One can then read back a whole lot of  
information about the pipeline at the time of the profiled  
instruction.  This can be used for statistical sampling.  Does the  
performance events subsystem support monitoring with such a mode?

Cheers
Michael.

