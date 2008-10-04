Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYJDAkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYJDAkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 20:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYJDAk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 20:40:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52626 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYJDAkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 20:40:25 -0400
Message-ID: <48E6BA5B.2090804@zytor.com>
Date: Fri, 03 Oct 2008 17:35:39 -0700
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
References: <1222881242.9381.17.camel@alok-dev1>	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1> <48E3FDD5.7040106@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com> <48E422CA.2010606@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA221@orsmsx505.amr.corp.intel.com> <48E6AB15.8060405@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA325@orsmsx505.amr.corp.intel.com>
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A15DCBA325@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> 
> What I mean is that a hypervisor (with a single vender id) can support multiple interfaces, exposing a single interface to each guest that would expect a specific interface at runtime.
> 

Yes, and for the reasons outlined in a previous post in this thread, 
this is an incredibly bad idea.  We already hate the guts of the ACPI 
people for this reason.

> 
> What's the significance of supporting multiple interfaces to the same guest simultaneously, i.e. _runtime_? We don't want the guests to run on such a literarily Frankenstein machine. And practically, such testing/debugging would be good only for Halloween :-).
> 

By that notion, EVERY CPU currently shipped is a "Frankenstein" CPU, 
since at very least they export Intel-derived and AMD-derived 
interfaces.  This is in other words, a ridiculous claim.

> The interface space can be distinct, but the contents are defined and implemented independently, thus you might find overlaps, inconsistency, etc. among the interfaces. And why is runtime "multiple interfaces" required for a standards-based interface?

That is the whole point -- without a central coordinating authority, 
you're going to have to accommodate many definition sources.  Otherwise, 
you're just back to where we started -- each hypervisor exports an 
interface and that's just that.

If there are multiple interface specifications, they should be exported 
simulateously in non-conflicting numberspaces, and the *GUEST* gets to 
choose what to believe.  We already do this for *all kinds* of 
information, including CPUID.  It's the right thing to do.

	-hpa

