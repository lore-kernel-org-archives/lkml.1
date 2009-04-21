Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZDUKO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZDUKO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZDUKOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:14:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50888 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbZDUKOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:14:14 -0400
Message-ID: <49ED9C70.5010906@redhat.com>
Date: Tue, 21 Apr 2009 13:14:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Xenner design and kvm msr handling
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com> <49EC68A7.8080403@redhat.com> <49EC6DEE.4070703@redhat.com> <49EC7797.7060004@redhat.com> <49EC7C5F.2000006@redhat.com> <49ED8E6D.80005@redhat.com>
In-Reply-To: <49ED8E6D.80005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> On 04/20/09 15:45, Avi Kivity wrote:
>
>> Please elaborate. What hypercalls are so simple that an exit into the
>> hypervisor is not necessary?
>
> Ok, that becomes a longer story.  I try to keep it short though ...
>

Thanks, this is very helpful.

>
> xenner & pv-on-hvm
> ==================
>
> Once we have all this in qemu it is just a small step to also support 
> xenish pv-on-hvm drivers in qemu using the xenner emulation bits. 
> Hypercalls are handled by a small pic binary loaded into the hypercall 
> pages.  Loading of the binary is triggered by the msr writes 
> discussed. Size of the binary is only two pages: one hypercall entry 
> points, one code.  Communication path is the very same ioport 
> interface also used by emu, i.e. it does *not* use vmcall and thus no 
> opcode changes are needed on migration.
>
This gives a good case for exporting MSRs to userspace.

Can you explain the protocol used by this MSR?  How does the guest know 
how many pages to load?  How does the kernel know which type of page to 
put where?

Note that it would still be interesting to have the guest call the 
kernel, so it can kick the host kernel Xen netback driver directly 
instead of going through qemu (and the userspace netback + tap).

-- 
error compiling committee.c: too many arguments to function

