Return-Path: <linux-kernel-owner+w=401wt.eu-S1423330AbXBPGP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423330AbXBPGP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423331AbXBPGP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:15:29 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48426 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423330AbXBPGP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:15:28 -0500
Message-ID: <45D54BFF.80100@vmware.com>
Date: Thu, 15 Feb 2007 22:15:27 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Avi Kivity <avi@qumranet.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070216022449.739760547@goop.org> <20070216022531.570154735@goop.org>
In-Reply-To: <20070216022531.570154735@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> The XEN config option enables the Xen paravirt_ops interface, which is
> installed when the kernel finds itself running under Xen. (By some
> as-yet fully defined mechanism, implemented in a future patch.)
>
> Xen is no longer a sub-architecture, so the X86_XEN subarch config
> option has gone.
>
> The disabled config options are:
> - PREEMPT: Xen doesn't support it
> - HZ: set to 100Hz for now, to cut down on VCPU context switch rate.
>   This will be adapted to use tickless later.
> - kexec: not yet supported
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
> Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>   

We do support different HZ values, although 100HZ is actually preferable 
for us, so I don't object to that.  PREEMPT is supported by us, but not 
as tested as I would like, so I also don't object to dropping it for 
generic paravirt guests - Rusty - Avi any objections to dropping preempt 
in terms of lguest/KVM paravirtualization?

Paravirt-ops definitely needs a hook for kexec, although we should not 
disable kexec for the natively booted paravirt-ops.  Eric - is there a 
way to disable it at runtime?

We do support the doublefault task gate, and it would be good to keep 
it, but I can't complain so much if it is gone from generic paravirt 
kernels for now, because it is non-essential, and generally fatal 
anyway.  We do need it for native boots of paravirt-ops kernels, 
however, so turning off the config option still needs to be revisited.

Zach
