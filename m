Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbXHVGAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbXHVGAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbXHVGAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:00:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbXHVGAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:00:39 -0400
Message-ID: <46CBD0F5.2080709@zytor.com>
Date: Tue, 21 Aug 2007 23:00:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com>
In-Reply-To: <46CBC842.4070100@vmware.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> In general, I/O in a virtual guest is subject to performance problems. 
> The I/O can not be completed physically, but must be virtualized.  This
> means trapping and decoding port I/O instructions from the guest OS. 
> Not only is the trap for a #GP heavyweight, both in the processor and
> the hypervisor (which usually has a complex #GP path), but this forces
> the hypervisor to decode the individual instruction which has faulted. 
> Worse, even with hardware assist such as VT, the exit reason alone is
> not sufficient to determine the true nature of the faulting instruction,
> requiring a complex and costly instruction decode and simulation.
> 
> This patch provides hypercalls for the i386 port I/O instructions, which
> vastly helps guests which use native-style drivers.  For certain VMI
> workloads, this provides a performance boost of up to 30%.  We expect
> KVM and lguest to be able to achieve similar gains on I/O intensive
> workloads.
> 

What about cost on hardware?

	-hpa
