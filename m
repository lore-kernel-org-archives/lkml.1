Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbXK0X4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbXK0X4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXK0X4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:56:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56438 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbXK0X4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:56:11 -0500
Date: Wed, 28 Nov 2007 00:56:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ben Woodard <woodard@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vivek Goyal <vgoyal@redhat.com>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071127235610.GD31491@one.firstfloor.org>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <20071127131355.GA14887@hmsendeavour.rdu.redhat.com> <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com> <200711271445.56792.ak@suse.de> <m1lk8jka8j.fsf@ebiederm.dsl.xmission.com> <474C64CB.7080004@redhat.com> <20071127194220.GG14887@hmsendeavour.rdu.redhat.com> <20071127200011.GA3703@redhat.com> <20071127222408.GH24223@one.firstfloor.org> <474CA733.9050908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474CA733.9050908@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Would anyone have any problems with code that simply verified that the 
> state which we are restoring allowed interrupts to get to the processor 
> that we are currently crashing on and if not, poked in a reasonable value.

Sounds reasonable by itself.

> 
> Yes this would add some complexity to the code paths where we were 
> crashing but it could prevent the problem that we are seeing. It seems 
> like a small fairly safe change rather than a big disruptive change like 
> moving the initialization of the IOAPIC earlier in the boot process.

But longer (or not so long) term moving the IOAPIC earlier is the better option, 
simply because the short use of PIC mode traditionally was a source of problems
on a lot of boxes.

And it does not really make sense to keep this source of trouble just for a short 
time during boot when we could as well go directly into IO-APIC mode. This would 
probably also match what other OS are doing better and that is always a good idea
for stable operation.

-Andi
