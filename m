Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0BSPh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:37:57 -0500
Received: from mga10.intel.com ([192.55.52.92]:33852 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750879Ab0BSPhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:37:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,503,1262592000"; 
   d="scan'208";a="774175083"
Message-ID: <4B7EB04E.8050601@linux.intel.com>
Date: Fri, 19 Feb 2010 16:37:50 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
References: <20100123113359.GA29555@one.firstfloor.org> <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu> <4B7B1C40.8070208@linux.intel.com> <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain> <20100219121734.GA8300@basil.fritz.box> <20100219124540.GC30243@aftab> <4B7E906D.8050501@linux.intel.com> <4B7EAB9E.2010509@redhat.com>
In-Reply-To: <4B7EAB9E.2010509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> EDAC is generic enough to work with different type of memory and memory
> controllers, and to provide a consistent interface to describe it on a way
> that userspace doesn't need to know what are the error registers at
> the hardware, nor how to decode a "magic" error number into something
> that has a meaning.

Well the main problem I have with EDAC is that it has far too much information
(e.g. down to ranks/banks and also too much information on
the internal topology of the memory controller, and it can't even
express some current designs).

For me it looks like it was designed by someone starring at a motherboard/DIMM
semantics plan, and I don't think that's the right level to think about
these things.

Going that deep typically
requires very hardware specific information and in some cases
it's not even possible. I also don't think it's useful information
to present (and it's really the opposite of "abstraction")

I also have yet to see a useful use case where you need to look "inside" a DIMM
on the reporting level. The useful level is typically the "FRU" (something
you can replace), with only some very specific extensions for special
use cases.

There's also no generic way to do the necessary enumeration down to
the level EDAC needs. For some cases hardware specific drivers can be written,
but it's always better if the generic case works in a architectural way.

Then it does all the enumeration on the kernel, but there
are no useful facilities to sync that with a user level representation.
And most of the useful advannced & interesting RAS features I'm interested in
need user level support.

I prefer at least for MCE to stay on the architectural level
with only minor extensions for specific use cases.

Now to address these problems you could throw large parts of EDAC
out (do you mean that with 'flexible enough'?) and then add a actual
event interface (working on the later is my plan)

> As Boris properly pointed, EDAC has space for improvements, and part of
> the perf logic can be used as a start point to give some flash new ideas.

See my analysis several mails up. Which parts of perf do you want
to actually use? I don't see any that's actually directly usable
without major changes.

> The main issue I see with MCE is at the interface level. I think if we
> all cope together, we can converge into a proper interface that will
> be accepted upstream.

Just that we're on the same level, could you spell out in detail
what problems you're seeing with it?

[I'm not claiming there are none, I'm just curious what you think they are]

-Andi

