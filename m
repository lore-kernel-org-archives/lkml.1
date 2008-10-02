Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbYJBB3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbYJBB3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYJBB2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:28:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYJBB2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:28:52 -0400
Message-ID: <48E422CA.2010606@zytor.com>
Date: Wed, 01 Oct 2008 18:24:26 -0700
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
References: <1222881242.9381.17.camel@alok-dev1>	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1> <48E3FDD5.7040106@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com>
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
>>
>> All I have seen out of Microsoft only covers CPUID levels 0x40000000
>> as an vendor identification leaf and 0x40000001 as a "hypervisor
>> identification leaf", but you might have access to other information.
> 
> No, it says "Leaf 0x40000001 as hypervisor vendor-neutral interface identification, which determines the semantics of leaves from 0x40000002 through 0x400000FF." The Leaf 0x40000000 returns vendor identifier signature (i.e. hypervisor identification) and the hypervisor CPUID leaf range, as in the proposal.
> 

In other words, 0x40000002+ is vendor-specific space, based on the 
hypervisor specified in 0x40000001 (in theory); in practice both 
0x40000000:0x40000001 since M$ seem to use clever identifiers as 
"Hypervisor 1".

>> This further underscores my belief that using 0x400000xx for anything
>> "standards-based" at all is utterly futile, and that this space should
>> be treated as vendor identification and the rest as vendor-specific.
>> Any hope of creating a standard that's actually usable needs to be
>> outside this space, e.g. in the 0x40SSSSxx space I proposed earlier.
> 
> Actually I'm not sure I'm following your logic. Are you saying using that 0x400000xx for anything "standards-based" is utterly futile because Microsoft said "the range is hypervisor vendor-neutral"? Or you were not sure what they meant there. If we are not clear, we can ask them.
> 

What I'm saying is that Microsoft is effectively squatting on the 
0x400000xx space with their definition.  As written, it's not even clear 
that it will remain consistent between *their own* hypervisors, even 
less anyone else's.

	-hpa

