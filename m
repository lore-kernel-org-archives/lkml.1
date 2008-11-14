Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYKNAkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYKNAkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYKNAj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:39:56 -0500
Received: from relay2.sgi.com ([192.48.179.30]:36827 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752621AbYKNAjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:39:55 -0500
Message-ID: <491CC8D7.7030306@sgi.com>
Date: Thu, 13 Nov 2008 16:39:51 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: paulus@samba.org, akpm@linux-foundation.org, yinghai@kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491CB421.2020701@sgi.com>	<20081113.151435.146617325.davem@davemloft.net>	<491CC310.3050807@sgi.com> <20081113.162144.155677034.davem@davemloft.net>
In-Reply-To: <20081113.162144.155677034.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Mike Travis <travis@sgi.com>
> Date: Thu, 13 Nov 2008 16:15:12 -0800
> 
>> David Miller wrote:
>>> From: Mike Travis <travis@sgi.com>
>>> Date: Thu, 13 Nov 2008 15:11:29 -0800
>>>
>>> We use a value of 256 and I've been booting linux on 128 cpu sparc64
>>> systems with lots of PCI-E host controllers (and others have booted it
>>> on even larger ones).  All of which have several NUMA domains.
>>>
>>> It's not an issue.
>> Are you saying that having a fixed count of IRQ's is not an issue?  With
>> NR_CPUS=4096 what would you fix it to?  (Currently it's NR_CPUS * 32
>> but that might not be sufficient.)  Would NR_CPUS=16384 make it an issue?
> 
> Nope, and nope.  I frequently run kernels with NR_CPUS set to huge
> values.
> 
> It seems that the issue of x86 is that it has it's IRQ count tied to
> the number of cpus, that's not very intelligent.  Perhaps that part
> should be rearranged somehow?

Yes, you're probably right but it is what it is.  Most of the irq vectors
have more to do with cpus than with i/o devices (the system vectors, ipi,
kdb and gru [a uv thing] interrupt vectors come first to mind.)  These do
by necessity need to grow with NR_CPUS, if you're fixing the total IRQ count.

There's been a couple of different proposals to attempt to disassociate
i/o and system vectors though even attempting to guess at the number of
i/o devices is tricky.  Every one of the 512 nodes on a UV system *may*
have a number of i/o devices attached to them though practically this
will be rare. 
