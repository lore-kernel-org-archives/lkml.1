Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZDTHxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZDTHxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbZDTHxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:53:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34778 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbZDTHxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:53:20 -0400
Message-ID: <49EC29D1.8040407@redhat.com>
Date: Mon, 20 Apr 2009 09:52:49 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com>
In-Reply-To: <49EAE1F6.9050205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/09 10:33, Avi Kivity wrote:
> Anthony Liguori wrote:
>> Why not introduce a new exit type for MSR reads/writes that aren't
>> handled by the kernel? You just need a bit on the return that
>> indicates whether to GPF because of an invalid MSR access.

Yes, please.

> Right now everything in the vcpu is emulated in the kernel. Everything
> else is emulated either in the kernel (irqchip) or in userspace. This
> makes things easier to understand, and is more future friendly if more
> cpu features become virtualized by hardware.
>
> While these are not compelling reasons, they at least lean the balance
> in favour of a kernel implementation.

The xen pv-on-hvm drivers use an msr to indicate "please place the 
hypercall page here".  Handling that in kernel isn't an option IMHO.

cheers,
   Gerd
