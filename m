Return-Path: <linux-kernel-owner+w=401wt.eu-S1761519AbYARODV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519AbYARODV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYARODP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:03:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYARODO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:03:14 -0500
Message-ID: <4790B01B.8020406@zytor.com>
Date: Fri, 18 Jan 2008 08:56:43 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Kyle McMartin <kyle@mcmartin.ca>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make clflush a required feature on x86_64
References: <20080118045921.GB974@phobos.i.cabal.ca> <p734pdbbrwu.fsf@bingen.suse.de> <20080118060124.GC1726@phobos.i.cabal.ca> <479046BA.7090903@zytor.com> <20080118065428.GA12594@one.firstfloor.org>
In-Reply-To: <20080118065428.GA12594@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Simulators can be fixed, 
> 
> They could, but why? I don't know of a good reason to require CLFLUSH.

Well, simulators are generally expected to follow the architecture, not 
vice versa.  I would tend to agree with the coupling that recent 
versions of Bochs appeared to have made here -- I think we're unlikely 
to see any processors with sse2 sans clflush, so keeping code branches 
in which will never be executed seems like a bad idea in the long term. 
  I'm much more worried about the possibility of embedded 64-bit CPUs 
who try to skimp on SSE2 than CLFLUSH.

Now, that being said, this being encapsulated in the required set (and 
unified, which means the branches will be executed on 32-bit hardware) 
it seems the impact of leaving them in is small for now.  We can 
re-evaluate that as appropriate.  Either way, we should *not* have 
#ifdef CONFIG_X86_64 around usage sites, circumventing the master 
switch.  It either goes in the required masks or it doesn't.

>> I just verified that Bochs 2.3.0 lacks this CPUID bit whereas the 
>> current version, 2.3.6, enables CLFLUSH iff SSE2 is enabled.  Qemu 0.9.0 
>> has CLFLUSH.  Andi, do you happen to know of any specific simulators 
>> which are problematic?  I would assume any recent version of SimNow is 
>> up to date.
> 
> I don't know of any specific ones that lack CLFLUSH, although Bochs
> definitely had similar problems in the past.

OK, so we're talking about outdated versions of Bochs, then?

	-hpa

