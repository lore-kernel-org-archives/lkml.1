Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZITTHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZITTHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 15:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZITTHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 15:07:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:7557 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbZITTHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 15:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,419,1249282800"; 
   d="scan'208";a="552176967"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: Don't ack_APIC_irq() if lapic is disabled in GENERIC_INTERRUPT_VECTOR handler
Date: Mon, 21 Sep 2009 03:07:42 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Dimitri Sivanich <sivanich@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <1252403546-12544-1-git-send-email-sheng@linux.intel.com> <20090920184203.GD32176@lenovo> <20090920184906.GE32176@lenovo>
In-Reply-To: <20090920184906.GE32176@lenovo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909210307.43996.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 September 2009 02:49:06 Cyrill Gorcunov wrote:
> [Cyrill Gorcunov - Sun, Sep 20, 2009 at 10:42:03PM +0400]
>
> | [Cyrill Gorcunov - Sun, Sep 20, 2009 at 10:30:11PM +0400]
> | ...
> |
> | | | > iirc it was Xen related patch. So it's not that simple.
> | | | >
> | | | > I've pointed out Sheng about disable_apic. I'm not Xen
> | | | > specialist but Xen team seem to use specific apic setup
> | | | > so our "dummy" operations are not involved (case they
> | | | > set disable_apic=1 without "turn off" apic ops in real).
> | | | > Something like that.
> | | |
> | | | They should then set a NOP function in that case. We really dont want
> | | | to slow down hotpath functions like smp_generic_interrupt() with
> | | | flaggery.
> | | |
> | | | 	Ingo
> | |
> | | Well, I suppose we should wait for Sheng's comments.
> | | I wish I would answer you but I simply don't know Xen
> | | code :)
> | |
> | | 	-- Cyrill
> |
> | Wait a bit Ingo, please. It seems I'm having different
> | patch series in mind. Need to restore mail thread.
> | Will back soon :)
> |
> | 	-- Cyrill
>
> yeah, it comes from Xen RFC series. Here is a quote from
> conversation.
>
> > Sheng Yan
> >
> > | | is there was some problem with it? I'm asking you
> > | | because if disable_apic=1 then any apic write/read
> > | | operations become NOPs. So I don't see how it may
> > | | hurt. But I could be missing something.
> > | |
> > | |   -- Cyrill
> > |
> > | Ah, I see -- it's due to your other patch...
> > | Hmm this makes all "disable apic" idea less
> > | general. And safety of ack_APIC_irq is now
> > | under suspicious.
> >
> > Um, probably. I've seen a ack_APIC_irq() in do_IRQ when handle_irq()
> > fail. Seems the assumption that ack_APIC_irq() always safe is there. I
> > will check if I can make it more elegant - maybe disable the warning in
> > the Xen code...
>
> Personally, I think "out-of-xen-thread" this patch is not needed.
> And if this apic-ack operation causes any kind of problems --
> this problem should be fixed without disable_apic involved.

In fact Xen set it to functional nop, but print warning when processing APIC 
access. So Xen assumed that no apic access would in the Xen path. But now this 
assumption have a little trouble with current hybrid implementation. I am 
working on to fix this issue now, so please ignore this patch temporarily, I 
would try to figure out a more elegant way to handle this issue and minimal  
the native impact.

Thanks.

-- 
regards
Yang, Sheng
 

