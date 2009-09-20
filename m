Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZITStH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZITStH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbZITStG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:49:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:11055 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZITStE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TjlvtHMqij5oLY08qqhjH5aZOhTbW5CRBE3wUed/wYplGYxb0stYPui26i/znCqDsb
         qT3xpLmeXVOF+jW5wbbDZ1boK6OeIuqSDlga+Mrrb41sZO0+yERUeutDKM6pw7irQbW3
         MlMxdUbJp1FszxAWH3EiWy9Dh40pNb2L5kNms=
Date: Sun, 20 Sep 2009 22:49:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Sheng Yang <sheng@linux.intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Dimitri Sivanich <sivanich@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Don't ack_APIC_irq() if lapic is disabled in
	GENERIC_INTERRUPT_VECTOR handler
Message-ID: <20090920184906.GE32176@lenovo>
References: <1252403546-12544-1-git-send-email-sheng@linux.intel.com> <20090920180632.GB8498@elte.hu> <20090920181326.GB32176@lenovo> <20090920182124.GD8498@elte.hu> <20090920183011.GC32176@lenovo> <20090920184203.GD32176@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920184203.GD32176@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Sep 20, 2009 at 10:42:03PM +0400]
| [Cyrill Gorcunov - Sun, Sep 20, 2009 at 10:30:11PM +0400]
| ...
| | | > 
| | | > iirc it was Xen related patch. So it's not that simple.
| | | > 
| | | > I've pointed out Sheng about disable_apic. I'm not Xen
| | | > specialist but Xen team seem to use specific apic setup
| | | > so our "dummy" operations are not involved (case they
| | | > set disable_apic=1 without "turn off" apic ops in real).
| | | > Something like that.
| | | 
| | | They should then set a NOP function in that case. We really dont want to 
| | | slow down hotpath functions like smp_generic_interrupt() with flaggery.
| | | 
| | | 	Ingo
| | | 
| | 
| | Well, I suppose we should wait for Sheng's comments.
| | I wish I would answer you but I simply don't know Xen
| | code :)
| | 
| | 	-- Cyrill
| 
| Wait a bit Ingo, please. It seems I'm having different
| patch series in mind. Need to restore mail thread.
| Will back soon :)
| 
| 	-- Cyrill

yeah, it comes from Xen RFC series. Here is a quote from
conversation.

> Sheng Yan
>
> | | is there was some problem with it? I'm asking you
> | | because if disable_apic=1 then any apic write/read
> | | operations become NOPs. So I don't see how it may
> | | hurt. But I could be missing something.
> | |
> | |   -- Cyrill
> |
> | Ah, I see -- it's due to your other patch...
> | Hmm this makes all "disable apic" idea less
> | general. And safety of ack_APIC_irq is now
> | under suspicious.
>
> Um, probably. I've seen a ack_APIC_irq() in do_IRQ when handle_irq() fail.
> Seems the assumption that ack_APIC_irq() always safe is there. I will check if
> I can make it more elegant - maybe disable the warning in the Xen code...
>

Personally, I think "out-of-xen-thread" this patch is not needed.
And if this apic-ack operation causes any kind of problems --
this problem should be fixed without disable_apic involved.

	-- Cyrill
