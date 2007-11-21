Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXKUNIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXKUNIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXKUNI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:08:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:48895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbXKUNI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:08:26 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc 08/45] cpu alloc: x86 support
Date: Wed, 21 Nov 2007 14:08:16 +0100
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <200711210236.33460.ak@suse.de> <Pine.LNX.4.64.0711201758350.30224@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711201758350.30224@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711211408.17078.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > All you need is a 2MB area (16MB is too large if you really
> > want 16k CPUs someday) somewhere in the -2GB or probably better
> > in +2GB. Then the linker puts stuff in there and you use
> > the offsets for referencing relative to %gs.
> 
> 2MB * 16k = 32GB. Even with 4k cpus we will have 2M * 4k = 8GB both do
> not fit in the 2GB area.

I was referring here to the 16MB/CPU you proposed originally which will not fit 
into _any_  kernel area for 16k CPUs. 

The whole mapping for all CPUs cannot fit into 2GB of course, but the reference 
linker managed range can.

> The offset relative to %gs cannot be used if you have a loop and are 
> calculating the addresses for all instances. That is what we are talking 
> about. The CPU_xxx operations that are using the %gs register are fine and 
> are not affected by the changes we are discussing.

Sure it can -- you just get the base address from a global array
and then add the offset

> 
> > Then the reference data would be initdata and eventually freed.
> > That is similar to how the current per cpu data works.
> 
> Yes that is also how the current patchset works. I just do not understand 
> what you want changed.

Anyways i think your current scheme cannot work (too much VM, placed at the wrong 
place; some wrong assumptions).

But since I seem unable to communicate this to you I'll stop commenting
and let you find it out the hard way. Have fun.

-Andi
