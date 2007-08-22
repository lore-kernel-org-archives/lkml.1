Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbXHVFeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbXHVFeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 01:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXHVFe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 01:34:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:37414 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbXHVFe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 01:34:26 -0400
Message-ID: <46CBCADF.2070400@qumranet.com>
Date: Wed, 22 Aug 2007 08:34:23 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com>
In-Reply-To: <46CBC842.4070100@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 22 Aug 2007 08:34:24 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> In general, I/O in a virtual guest is subject to performance
> problems.  The I/O can not be completed physically, but must be
> virtualized.  This means trapping and decoding port I/O instructions
> from the guest OS.  Not only is the trap for a #GP heavyweight, both
> in the processor and the hypervisor (which usually has a complex #GP
> path), but this forces the hypervisor to decode the individual
> instruction which has faulted.  Worse, even with hardware assist such
> as VT, the exit reason alone is not sufficient to determine the true
> nature of the faulting instruction, requiring a complex and costly
> instruction decode and simulation.
>
> This patch provides hypercalls for the i386 port I/O instructions,
> which vastly helps guests which use native-style drivers.  For certain
> VMI workloads, this provides a performance boost of up to 30%.  We
> expect KVM and lguest to be able to achieve similar gains on I/O
> intensive workloads.
>


Won't these workloads be better off using paravirtualized drivers? 
i.e., do the native drivers with paravirt I/O instructions get anywhere
near the performance of paravirt drivers?


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

