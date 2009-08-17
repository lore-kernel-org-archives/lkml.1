Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZHQSxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZHQSxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZHQSxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:53:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZHQSxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:53:42 -0400
Message-ID: <4A89A724.406@zytor.com>
Date: Mon, 17 Aug 2009 11:53:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Mark Kelly <mark@bifferos.com>,
       linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86 CPU detection for RDC
References: <58001.1250437590@bifferos.com> <20090816155507.GA2791@elte.hu>	<alpine.LNX.2.00.0908160317250.19588@cent.localnet>	<20090816175204.GA28553@elte.hu>	<alpine.LNX.2.00.0908160404300.20653@cent.localnet>	<4A899A1D.8060808@zytor.com> <20090817180825.GA5558@elte.hu>	<4A899FEA.9020707@zytor.com> <871vnas2gn.fsf@basil.nowhere.org>
In-Reply-To: <871vnas2gn.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 11:46 AM, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> On 08/17/2009 11:08 AM, Ingo Molnar wrote:
>>> X86_RDC321X already exists in arch/x86/Kconfig. It should probably 
>>> grow a 'depends on PCI' rline or so.
>>>
>> Sounds like it.
> 
> iirc the patch used early pci which is actually self contained
> in its header. The main problem was that it didn't use it correctly.
> 

It isn't a matter of if compilation works, it is a matter of if we
should even try to probe PCI if the user has explicitly disabled
CONFIG_PCI.  arch/x86/kernel/cpu/cyrix.c disables its PCI probing if
CONFIG_PCI is off, even though it also uses <asm/pci-direct.h>.

Given that the benefit of this CPU detection patch is extremely small
(all it does it get better information in /proc/cpuinfo) and that blind
probing can have disastrous consequences, I would say it should not.

	-hpa

