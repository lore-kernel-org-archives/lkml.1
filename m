Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbXK2T1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbXK2T1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXK2T1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:27:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52938 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352AbXK2T1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:27:24 -0500
Date: Thu, 29 Nov 2007 20:27:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, zach@vmware.com
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
Message-ID: <20071129192721.GP24223@one.firstfloor.org>
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org> <474F01F6.2030509@zytor.com> <alpine.LFD.0.9999.0711291027070.8458@woody.linux-foundation.org> <474F08E1.2090806@zytor.com> <alpine.LFD.0.9999.0711291057320.8458@woody.linux-foundation.org> <474F1027.2020801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474F1027.2020801@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 11:16:55AM -0800, H. Peter Anvin wrote:
> Andi, do you happen to remember the details on this?

x86-64 has to use GS because there is no SWAPFS
We decided to make it opposite on user space back then, but not
based on benchmarks (there were only simulators back then)  Oh yes
the reason was that the GS context switch is slightly more expensive
than the FS one and the code does lazy optimization.

For i386 iirc Jeremy/Zach did the benchmarking and they settled
on %fs because it was faster for something (originally it was %gs too) 

-Andi
