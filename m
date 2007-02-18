Return-Path: <linux-kernel-owner+w=401wt.eu-S1750703AbXBRLcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750703AbXBRLcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 06:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXBRLcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 06:32:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:50302 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbXBRLcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 06:32:52 -0500
Message-ID: <45D83947.8080505@qumranet.com>
Date: Sun, 18 Feb 2007 13:32:23 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070216022449.739760547@goop.org> <20070216022531.570154735@goop.org> <45D54BFF.80100@vmware.com>
In-Reply-To: <45D54BFF.80100@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Jeremy Fitzhardinge wrote:
>> The XEN config option enables the Xen paravirt_ops interface, which is
>> installed when the kernel finds itself running under Xen. (By some
>> as-yet fully defined mechanism, implemented in a future patch.)
>>
>> Xen is no longer a sub-architecture, so the X86_XEN subarch config
>> option has gone.
>>
>> The disabled config options are:
>> - PREEMPT: Xen doesn't support it
>> - HZ: set to 100Hz for now, to cut down on VCPU context switch rate.
>>   This will be adapted to use tickless later.
>> - kexec: not yet supported
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
>> Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
>> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>>   
>
> We do support different HZ values, although 100HZ is actually 
> preferable for us, so I don't object to that.  

Ditto for kvm.

> PREEMPT is supported by us, but not as tested as I would like, so I 
> also don't object to dropping it for generic paravirt guests - Rusty - 
> Avi any objections to dropping preempt in terms of lguest/KVM 
> paravirtualization?

I don't have any objections myself, but Ingo (who has done the bulk of 
the kvm paravirt work; cc'ed) uses PREEMPT_RT, so he will certainly object.

>
> Paravirt-ops definitely needs a hook for kexec, although we should not 
> disable kexec for the natively booted paravirt-ops.  Eric - is there a 
> way to disable it at runtime?

kvm paravirt should work correctly with kexec.

>
> We do support the doublefault task gate, and it would be good to keep 
> it, but I can't complain so much if it is gone from generic paravirt 
> kernels for now, because it is non-essential, and generally fatal 
> anyway.  We do need it for native boots of paravirt-ops kernels, 
> however, so turning off the config option still needs to be revisited.

kvm doesn't support task gates (a task switch will immediately kill the 
guest).


-- 
error compiling committee.c: too many arguments to function

