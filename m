Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbZDTJA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbZDTJA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZDTJAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:00:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52743 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZDTJAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:00:07 -0400
Message-ID: <49EC3987.2040001@redhat.com>
Date: Mon, 20 Apr 2009 10:59:51 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com>
In-Reply-To: <49EC3198.9070902@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/09 10:26, Avi Kivity wrote:
> Gerd Hoffmann wrote:
>> The xen pv-on-hvm drivers use an msr to indicate "please place the
>> hypercall page here". Handling that in kernel isn't an option IMHO.
>
> The contents of the hypercall page are vendor specific. This can be
> handled from userspace (though ideally we'd abstract the cpu vendor
> away).

Well, xenner doesn't do vmcalls, so the page isn't vendor specific.  It 
looks different for 32bit / 64bit guests though.  And it actually can be 
multiple pages (with one msr write per page).  So the interface for 
in-kernel handling would be more complex than "here is a hypercall page 
for you".

 > The Hyper-V hypercall page is more problematic, as it's specified to 
 > be an overlay; the page doesn't have to exist in guest RAM.

In userspace it should be easy to handle though as qemu can just create 
a new memory slot, right?

cheers,
   Gerd
