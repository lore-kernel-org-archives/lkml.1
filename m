Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZDTJGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZDTJGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZDTJFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:05:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40160 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbZDTJFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:05:38 -0400
Message-ID: <49EC3AD6.3090905@redhat.com>
Date: Mon, 20 Apr 2009 12:05:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com>
In-Reply-To: <49EC3987.2040001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> On 04/20/09 10:26, Avi Kivity wrote:
>> Gerd Hoffmann wrote:
>>> The xen pv-on-hvm drivers use an msr to indicate "please place the
>>> hypercall page here". Handling that in kernel isn't an option IMHO.
>>
>> The contents of the hypercall page are vendor specific. This can be
>> handled from userspace (though ideally we'd abstract the cpu vendor
>> away).
>
> Well, xenner doesn't do vmcalls, so the page isn't vendor specific.  

Well, for true pv (not pv-on-hvm) it wouldn't use the MSR, would it?

> It looks different for 32bit / 64bit guests though.  And it actually 
> can be multiple pages (with one msr write per page).  So the interface 
> for in-kernel handling would be more complex than "here is a hypercall 
> page for you".

To different MSRs, or multiple writes to the same MSR?

>
> > The Hyper-V hypercall page is more problematic, as it's specified to 
> > be an overlay; the page doesn't have to exist in guest RAM.
>
> In userspace it should be easy to handle though as qemu can just 
> create a new memory slot, right?

It depends if the MSR may be considered global, or is required to be 
per-cpu.  Need to refresh my memory on this, but I remember reading this 
and saying 'yuck'.

-- 
error compiling committee.c: too many arguments to function

