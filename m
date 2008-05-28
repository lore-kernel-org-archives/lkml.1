Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYE1KlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYE1KlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 06:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYE1Kk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 06:40:58 -0400
Received: from gw.goop.org ([64.81.55.164]:40070 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbYE1Kk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 06:40:58 -0400
Message-ID: <483D3697.1070702@goop.org>
Date: Wed, 28 May 2008 11:40:23 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: Question about interrupt routing and irq allocation
References: <483B34CA.8000600@goop.org> <20080527083729.GF29246@elte.hu>	<483BD843.5080009@goop.org> <20080527145606.GB24457@elte.hu>	<483C35AA.5060102@goop.org> <m1ve0yai0j.fsf@frodo.ebiederm.org>
In-Reply-To: <m1ve0yai0j.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> - I think using create_irq is a good step.
> - I think all vectors are wasted in the case of Xen.
>   

The case I'm discussing now is in hvm domains - ie, fully virtualized PC 
platform. I'm adding a driver to poke a hole through all the emulated 
hardware to get directly to the underlying Xen layer so that we can run 
paravirtual drivers to get better performance. Only the irqs associated 
with pv drivers will waste their vectors.

> - I think we want a individual irq for each xen irq source.
>   Sparc already does a demux in similar circumstances with
>   a queue of received MSI messages an a single cpu irq
>   that these get demuxed from.
>   If we don't have individual irqs per drivers it will be hard
>   to share a source base with native drivers.
>   

In this case the sharing is between fully paravirtualized paravirt_ops 
Xen and pv-on-hvm drivers. In general I want those drivers to look as 
normal as possible, so they should use irqs in a normal way.

> - I think it would be very nice if we could get irqs allocated
>   in request_irq instead of create_irq (and equivalents).
>   

Something along the lines of passing -1 as the irq, and it would return 
the allocated irq? It's not clear to me how all that would fit together.

> - I think ultimately it makes sense to port the per vector
>   code to 32bit linux.  On single cpu systems the cost should
>   be just a hair more code, but no extra data structures.  We
>   can easily restrict the irq allocation to allocating the same
>   vector on all cpus for any old machines that prove flaky with
>   irq migration.
>
>   The code between the two architectures we kept fairly close
>   in sync when I worked on it so a merge should not be a big deal.

Well, if I find myself at a loose end, I'll have a look at it.
