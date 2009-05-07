Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbZEGOeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbZEGOeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZEGOeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:34:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44542 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbZEGOeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:34:11 -0400
Message-ID: <4A02F160.7080907@redhat.com>
Date: Thu, 07 May 2009 17:34:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, viro@ZenIV.linux.org.uk,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com> <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com> <4A02AE65.3000800@redhat.com> <20090507134607.GA25311@amt.cnet> <4A02E9C5.7020704@novell.com>
In-Reply-To: <4A02E9C5.7020704@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> One thing I was thinking here was that I could create a flag for the
> kvm_irqfd() function for something like "KVM_IRQFD_MODE_CLEAR".  This
> flag when specified at creation time will cause the event to execute a
> clear operation instead of a set when triggered.  That way, the default
> mode is an edge-triggered set.  The non-default mode is to trigger a
> clear.  Level-triggered ints could therefore create two irqfds, one for
> raising, the other for clearing.
>   

That's my second choice option.

> An alternative is to abandon the use of eventfd, and allow the irqfd to
> be a first-class anon-fd.  The parameters passed to the write/signal()
> function could then indicate the desired level.  The disadvantage would
> be that it would not be compatible with eventfd, so we would need to
> decide if the tradeoff is worth it.
>   

I would really like to keep using eventfd.  Which is why I asked Davide 
about the prospects of direct callbacks (vs wakeups).

> OTOH, I suspect level triggered interrupts will be primarily in the
> legacy domain, so perhaps we do not need to worry about it too much. 
> Therefore, another option is that we *could* simply set the stake in the
> ground that legacy/level cannot use irqfd.
>   

This is my preferred option.  For a virtio-net-server in the kernel, 
we'd service its eventfd in qemu, raising and lowering the pci interrupt 
in the traditional way.

But we'd still need to know when to lower the interrupt.  How?

-- 
error compiling committee.c: too many arguments to function

