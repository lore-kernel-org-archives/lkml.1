Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZE2X0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZE2X0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 19:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZE2X0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 19:26:41 -0400
Received: from claw.goop.org ([74.207.240.146]:47775 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbZE2X0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 19:26:40 -0400
Message-ID: <4A206F2F.2040700@goop.org>
Date: Fri, 29 May 2009 16:26:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Jiang, Yunhong" <yunhong.jiang@intel.com>
Subject: Re: [Xen-devel] Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>	<20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org>	<20090528.210559.137121893.davem@davemloft.net>	<4A1FCE8E.2060604@eu.citrix.com> <87tz33ep1b.fsf@basil.nowhere.org> <0B53E02A2965CE4F9ADB38B34501A3A188156C9C@orsmsx505.amr.corp.intel.com>
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A188156C9C@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> I think we still need some (or all?) of additional dom0 PV ops even for HVM (Hardware-based VM) dom0. Hardware-based virtualization can significantly clean up the CPU-related PV ops (including some for local APIC), but they have nothing to do with dom0.
>
> Some hooks in the host could be removed by reusing the HVM-specific code with modifications to the virtualization logic, but I think people need to tell which specific ones are intrusive, to be fair.
>   

I think two things will significantly clean up the dom0 apic patches:

    One is to adjust the LAPIC and IOAPIC probing code so that it
    behaves correctly if the APIC cpuid flag is clear.  That would
    remove a lot of the init-time ad-hoc Xen changes I made.

    The other is to implement Ingo's suggestion of a proper ioapic
    driver layer.  I think that would not only resolve the low-level
    IO-APIC register access issue, but probably clean up a lot of the
    vector allocation/handling, and make a clear path for MSI support. 
    With luck it will also clean up things like x2apic support

I'm planning on putting some time into investigating these next week.

Once we've nailed down the details of how to make PAT work for PV guests 
on the Xen side, we should be able to implement that fairly easily in 
Linux with no core x86 changes.

I really don't think emulating MTRR register writes is the right way to 
implement Xen MTRR support, given that a much more semantically 
appropriate interface already exists, but we can do that if nothing else 
gets merged.

IanC is restructuring the swiotlb changes in a way that I hope will be 
acceptable to all.

At that point, I think we really will have resolved all the high-level 
concerns expressed about the overall architecture of the patches, and 
maybe we can finally see some progress.

    J
