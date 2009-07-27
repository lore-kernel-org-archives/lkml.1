Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZG0Joq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZG0Joq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbZG0Joq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:44:46 -0400
Received: from goliath.siemens.de ([192.35.17.28]:17753 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbZG0Jop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:44:45 -0400
X-Greylist: delayed 2142 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 05:44:44 EDT
Message-ID: <4A6D6E9A.6030400@siemens.com>
Date: Mon, 27 Jul 2009 11:08:42 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Yang, Sheng" <sheng.yang@intel.com>
CC: "H. Peter Anvin" <h.peter.anvin@intel.com>, Avi Kivity <avi@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       kvm-devel <kvm@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: cpuinfo and HVM features (was: Host latency peaks due to kvm-intel)
References: <4A68A6E5.6010808@siemens.com> <4A6AD69E.7030201@web.de> <4A6CAB8B.4080706@intel.com> <200907270912.00470.sheng.yang@intel.com>
In-Reply-To: <200907270912.00470.sheng.yang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ carrying this to LKML ]

Yang, Sheng wrote:
> On Monday 27 July 2009 03:16:27 H. Peter Anvin wrote:
>> Jan Kiszka wrote:
>>> Avi Kivity wrote:
>>>> On 07/24/2009 12:41 PM, Jan Kiszka wrote:
>>>>> I vaguely recall that someone promised to add a feature reporting
>>>>> facility for all those nice things, modern VM-extensions may or may not
>>>>> support (something like or even an extension of /proc/cpuinfo). What is
>>>>> the state of this plan? Would be specifically interesting for Intel
>>>>> CPUs as there seem to be many of them out there with restrictions for
>>>>> special use cases - like real-time.
>>>> Newer kernels do report some vmx features (like flexpriority) in
>>>> /proc/cpuinfo but not all.
>>> Ah, nice. Then we just need this?
>> Fine with me.
>>
>> Acked-by: H. Peter Anvin <hpa@zytor.com>
>>
>> However, I guess the real question if we shouldn't export ALL VMX
>> features in a consistent way instead?
>>
> When I add feature reporting to cpuinfo, I just put highlight features there, 
> otherwise the VMX feature list would at least as long as CPU one.

That could become true. But the question is always what the highlights
are. Often this depends on the hypervisor as it may implement
workarounds for missing features differently (or not at all). So I'm
also for exposing feature information consistently.

> 
> I have also suggested another field for virtualization feature for it, but 
> some concern again userspace tools raised.
> 
> For we got indeed quite a lot features, and would get more, would it better to 
> export the part of struct vmcs_config entries(that's pin_based_exec_ctrl, 
> cpu_based_exec_ctrl, and cpu_based_2nd_exec_ctrl) through 
> sys/module/kvm_intel/? Put every feature to cpuinfo seems not that necessary 
> for such a big list.

I don't think this information should only come from KVM. Consider you
didn't build it into some kernel but still want to find out what your
system is able to provide.

What about adding some dedicated /proc entry for CPU virtualization
features, say /proc/hvminfo?

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
