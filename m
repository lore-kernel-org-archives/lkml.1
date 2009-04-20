Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZDTL2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZDTL2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZDTL2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:28:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60326 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbZDTL2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:28:01 -0400
Message-ID: <49EC5C3A.6020108@redhat.com>
Date: Mon, 20 Apr 2009 14:27:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com>
In-Reply-To: <49EC5B2A.9080403@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
>>> Well, xenner doesn't do vmcalls, so the page isn't vendor specific.
>>
>> Well, for true pv (not pv-on-hvm) it wouldn't use the MSR, would it?
>
> Yes, the MSR is used for pv-on-hvm only.

So it isn't relevant for Xenner?

That said, I'd like to be able to emulate the Xen HVM hypercalls.  But 
in any case, they hypercall implementation has to be in the kernel, so I 
don't see why the MSR shouldn't be.  Especially if we need to support 
tricky bits like continuations.

> Same MSR, multiple writes (page number in the low bits).

Nasty.  The hypervisor has to remember all of the pages, so it can 
update them for live migration.  And it has to forget about them on 
reset.  And something needs to be done for kexec...

-- 
error compiling committee.c: too many arguments to function

