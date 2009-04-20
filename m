Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZDTLXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZDTLXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZDTLXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:23:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40675 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbZDTLXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:23:33 -0400
Message-ID: <49EC5B2A.9080403@redhat.com>
Date: Mon, 20 Apr 2009 13:23:22 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com>
In-Reply-To: <49EC3AD6.3090905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/09 11:05, Avi Kivity wrote:
> Gerd Hoffmann wrote:
>> On 04/20/09 10:26, Avi Kivity wrote:
>>> Gerd Hoffmann wrote:
>>>> The xen pv-on-hvm drivers use an msr to indicate "please place the
>>>> hypercall page here". Handling that in kernel isn't an option IMHO.
>>>
>>> The contents of the hypercall page are vendor specific. This can be
>>> handled from userspace (though ideally we'd abstract the cpu vendor
>>> away).
>>
>> Well, xenner doesn't do vmcalls, so the page isn't vendor specific.
>
> Well, for true pv (not pv-on-hvm) it wouldn't use the MSR, would it?

Yes, the MSR is used for pv-on-hvm only.

>> It looks different for 32bit / 64bit guests though. And it actually
>> can be multiple pages (with one msr write per page). So the interface
>> for in-kernel handling would be more complex than "here is a hypercall
>> page for you".
>
> To different MSRs, or multiple writes to the same MSR?

Same MSR, multiple writes (page number in the low bits).

cheers,
   Gerd

