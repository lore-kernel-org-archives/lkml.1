Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYKBB0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYKBB0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 21:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYKBB0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 21:26:31 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:34417 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYKBB0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 21:26:30 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=ch6Nv3cxIjphNjusNEgA:9 a=GeGRDC7NDP2ot5w5KtkA:7 a=eFnWClN_dhzEpewC0io560JJQCQA:4
Message-ID: <490D01C4.7090106@shaw.ca>
Date: Sat, 01 Nov 2008 19:26:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jonathan Corbet <corbet@lwn.net>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no> <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com> <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org> <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org> <20081031100040.1f0cf34f@bike.lwn.net> <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org> <20081031105105.092ebad3@bike.lwn.net> <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org> <20081101090154.3d014f57@bike.lwn.net> <alpine.LFD.2.00.0811010958230.6226@nehalem.linux-foundation.org> <86802c440811011250g662b8c4di31f2e391c910954e@mail.gmail.com> <20081101164509.5e53762c@bike.lwn.net> <alpine.LFD.2.00.0811011609050.3483@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811011609050.3483@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 1 Nov 2008, Jonathan Corbet wrote:
>> Looks to me like Linus's patch is the way to go, at least for now...
> 
> I'll make an -rc3 tomorrow. However, I suspect that if we have lots more 
> regressions, we'll just have to revert the resource handling back to the
> 2.6.27 state.
> 
> The problem with resource handling is that even when we can write code 
> that "makes sense", in the end firmware can always do odd things. For 
> example, in your case it really does make sense to keep the already 
> allocated PCI resources in the reserved region, because the firmware 
> obviously did both the reserved region _and_ the PCI BAR allocation.
> 
> At the same time, I'm worried that what Windows does is something totally 
> different, probably odd, and possibly even dependent on some HAL layer 
> motherboard driver or other.  And it's really the case that every single 
> time we change resource allocation - never mind how subtly, or how much 
> sense it makes - it will break some odd setup somewhere.

As far as I understand, Windows (at least with the ACPI HAL, which all 
remotely modern PCs will use) essentially uses the E820 map for 
determining usable RAM addresses only. It doesn't really care about 
what's reserved in that map, it expects the truly reserved ranges to be 
reserved as ACPI motherboard resources. (Though, it seems like it will 
still happily allow device BARs to overlap those ACPI reservations, at 
least if the BIOS put them there to start with..)
