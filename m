Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZB1QQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZB1QQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 11:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZB1QQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 11:16:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35201 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZB1QQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 11:16:08 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] xen: core dom0 support
From: Andi Kleen <andi@firstfloor.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
	<20090227212812.26d02f34.akpm@linux-foundation.org>
	<49A8DF28.4050301@goop.org>
Date: Sat, 28 Feb 2009 17:14:15 +0100
In-Reply-To: <49A8DF28.4050301@goop.org> (Jeremy Fitzhardinge's message of "Fri, 27 Feb 2009 22:52:24 -0800")
Message-ID: <87eixi35ew.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Andrew Morton wrote:
>> On Fri, 27 Feb 2009 17:59:06 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>
>>> This series implements the core parts of Xen dom0 support; that is, just
>>> enough to get the kernel started when booted by Xen as a dom0 kernel.
>>>
>>
>> And what other patches can we expect to see to complete the xen dom0
>> support?
>>
>
> There's a bit of a gradient.  There's probably another 2-3 similarly
> sized series to get everything so that you can boot dom0 out of the
> box (core, apic, swiotlb/agp/drm, backend drivers, tools).  And then a
> scattering of smaller things which may or may not be upstreamable.
> The vast majority of it is Xen-specific code, rather than changes to
> core kernel.  

I would say the more interesting question is less how much additional
code it is or even how much it changes the main kernel, but more how
different the code execution paths in interaction with Xen are
compared to what a native kernel would do. Because such differences
always would need to be considered in future changes.

For example things like: doesn't use PAT with Xen or apparently very
different routing are somewhat worrying because it means it's a
completely different operation modus with Xen that needs to be taken
care of later, adding to complexity.

Unfortunately it also looks like that Xen the HV does things
more and more different from what mainline kernel does so 
these differences will likely continue to grow over time.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
