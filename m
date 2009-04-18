Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZDRWRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZDRWRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 18:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZDRWRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 18:17:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:32714 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZDRWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 18:17:03 -0400
Message-ID: <49EA515C.9000507@codemonkey.ws>
Date: Sat, 18 Apr 2009 17:17:00 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com>
In-Reply-To: <49E337D7.5050502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote: 
>
> Then we would need to tell which read-only MSRs are setup writeable 
> and which aren't...
>
> I'm okay with an ioctl to setup MCE, but just make sure userspace has 
> all the information to know what the kernel can do rather than the 
> try-and-see-if-it-works approach.  We can publish this information via 
> KVM_CAP things, or via another ioctl (see KVM_GET_SUPPORTED_CPUID2 for 
> an example).

Why not introduce a new exit type for MSR reads/writes that aren't 
handled by the kernel?  You just need a bit on the return that indicates 
whether to GPF because of an invalid MSR access.

KVM_SET_MSRs should be reserved for MSRs that are performance 
sensitive.  Not all of them will be.

Regards,

Anthony Liguori

