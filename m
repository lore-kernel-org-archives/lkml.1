Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXKUCIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXKUCIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 21:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbXKUCIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 21:08:42 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36360 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbXKUCIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 21:08:42 -0500
Date: Tue, 20 Nov 2007 18:08:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <200711210236.33460.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0711201758350.30224@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com>
 <Pine.LNX.4.64.0711201607460.29220@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711201703570.29648@schroedinger.engr.sgi.com>
 <200711210236.33460.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Andi Kleen wrote:

> On Wednesday 21 November 2007 02:16:11 Christoph Lameter wrote:
> > But one can subtract too... 
> 
> The linker cannot subtract (unless you add a new relocation types) 

The compiler knows and emits assembly to compensate.

> All you need is a 2MB area (16MB is too large if you really
> want 16k CPUs someday) somewhere in the -2GB or probably better
> in +2GB. Then the linker puts stuff in there and you use
> the offsets for referencing relative to %gs.

2MB * 16k = 32GB. Even with 4k cpus we will have 2M * 4k = 8GB both do
not fit in the 2GB area.

The offset relative to %gs cannot be used if you have a loop and are 
calculating the addresses for all instances. That is what we are talking 
about. The CPU_xxx operations that are using the %gs register are fine and 
are not affected by the changes we are discussing.

> Then for all CPUs (including CPU #0) you put the real mapping
> somewhere else, copy the reference data there (which also doesn't need
> to be on the offset the linker assigned, just on a constant offset
> from it somewhere in the normal kernel data) and off you go.

Real mapping? We have constant offsets after this patchset. I do not get 
what you are planning here.

> Then the reference data would be initdata and eventually freed.
> That is similar to how the current per cpu data works.

Yes that is also how the current patchset works. I just do not understand 
what you want changed.

