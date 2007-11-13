Return-Path: <linux-kernel-owner+w=401wt.eu-S1760391AbXKMAM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391AbXKMAM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759765AbXKMAMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:12:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57742 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747AbXKMAMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:12:46 -0500
Message-ID: <4738EBB6.7060605@zytor.com>
Date: Mon, 12 Nov 2007 16:11:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [patch] x86: fix taking DNA during 64bit sigreturn
References: <20071111192758.GA21851@linux-os.sc.intel.com> <alpine.LFD.0.9999.0711121044130.30499@woody.linux-foundation.org> <200711122216.40663.ak@suse.de>
In-Reply-To: <200711122216.40663.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The *real* fix for this is almost certainly to just get rid of the 64-bit 
>> code entirely, and use the 32-bit code as the base for one single unified 
>> setup.
> 
> That would likely break the ABI. x86-64 ABI is completely different here --
> no ibcs, just pure x86 ISA.
> 

Different ABIs clearly have to be handled, but I don't think that is a 
huge deal.  The i387 code overall (not just asm/i387.h) is very 
different, though, and I find it unlikely that a properly unified code 
is going to be ready and working in the 2.6.24 timeframe.  I'm exploring 
if a partial merge with high confidence level is feasible; either way, a 
proper merge for 2.6.25 is probably the right thing.

	-hpa
