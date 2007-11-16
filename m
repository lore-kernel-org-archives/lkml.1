Return-Path: <linux-kernel-owner+w=401wt.eu-S934487AbXKPAnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487AbXKPAnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbXKPAnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:43:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39126 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbXKPAnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:43:16 -0500
Message-ID: <473CE72C.4060209@zytor.com>
Date: Thu, 15 Nov 2007 16:41:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org> <473CCB66.2080601@zytor.com> <20071116004012.GE1806@holomorphy.com>
In-Reply-To: <20071116004012.GE1806@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> 
> There may be bigger fish to fry in terms of per-process overhead, if
> you're trying to cut that down. The trouble with trying to address
> some of those is that there is mutual antagonism between compactness
> and expansibility in the process address space layout, so you'll end
> up instantiating a lot more than you want barring some sort of provision
> for a compact address space layout. Pagetable sharing is a far more
> powerful resource scalability method, though it also needs cooperation
> in user address space layout to reap its gains.
> 
> There are other overheads, of course, though they're more typically
> per-something besides processes.
> 

I think Jeremy's question was due to trying to reduce the 32/64-bit 
differences.  Performance-wise, it might add a small amount to user 
setup time (a typical 32-bit process will need all four, for the main 
binary, libraries, stack and kernel, respectively) but it is probably 
not significant (although I'd like to see numbers just in case).

	-hpa

