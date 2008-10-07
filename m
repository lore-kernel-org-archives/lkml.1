Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYJGWlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYJGWlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYJGWl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:41:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYJGWlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:41:25 -0400
Message-ID: <48EBE499.5000304@zytor.com>
Date: Tue, 07 Oct 2008 15:37:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: "akataria@vmware.com" <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
References: <1222881242.9381.17.camel@alok-dev1>	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1> <48E3FDD5.7040106@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com> <48E422CA.2010606@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA221@orsmsx505.amr.corp.intel.com> <48E6AB15.8060405@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA325@orsmsx505.amr.corp.intel.com> <48E6BA5B.2090804@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DE4F934@orsmsx505.amr.corp.intel.com>
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A15DE4F934@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> On 10/3/2008 5:35:39 PM, H. Peter Anvin wrote:
>> Nakajima, Jun wrote:
>>> What's the significance of supporting multiple interfaces to the
>>> same guest simultaneously, i.e. _runtime_? We don't want the guests
>>> to run on such a literarily Frankenstein machine. And practically,
>>> such testing/debugging would be good only for Halloween :-).
>>>
>> By that notion, EVERY CPU currently shipped is a "Frankenstein" CPU,
>> since at very least they export Intel-derived and AMD-derived interfaces.
>>  This is in other words, a ridiculous claim.
> 
> The big difference here is that you could create a VM at runtime (by combining the existing interfaces) that did not exist before (or was not tested before). For example, a hypervisor could show hyper-v, osx-v (if any), linux-v, etc., and a guest could create a VM with hyper-v MMU, osx-v interrupt handling, Linux-v timer, etc. And such combinations/variations can grow exponentially.
> 
> Or are you suggesting that multiple interfaces be _available_ to guests at runtime but the guest chooses one of them?
> 

The guest chooses what it wants to use.  We already do this: for 
example, we use CPUID leaf 0x80000006 preferentially to CPUID leaf 2, 
simply because it is a better interface.

And you're absolutely right that the guest may end up picking and 
choosing different parts of the interfaces.  That's how it is supposed 
to work.

	-hpa
