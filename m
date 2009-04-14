Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbZDNKo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbZDNKo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZDNKon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:44:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57204 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZDNKol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:44:41 -0400
Message-ID: <49E4693B.4080707@redhat.com>
Date: Tue, 14 Apr 2009 13:45:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com>	 <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com>	 <49E337D7.5050502@redhat.com> <1239674697.20762.34.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1239674697.20762.34.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
>> I'm okay with an ioctl to setup MCE, but just make sure userspace has 
>> all the information to know what the kernel can do rather than the 
>> try-and-see-if-it-works approach.  We can publish this information via 
>> KVM_CAP things, or via another ioctl (see KVM_GET_SUPPORTED_CPUID2 for 
>> an example).
>>     
>
> Yes. MCE support should be published by KVM_CAP_MCE and other features
> can be published via reading the default value of MSR_IA32_MCG_CAP.
>   

A problem with this is that you can only read an MSR after a vcpu has 
been created.  But if you're writing a program to detect what features 
are available (for example, when checking features common to a migration 
pool), you don't want to create a vpcu (you could, but it's hacky).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

