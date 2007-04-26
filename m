Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbXDZUXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbXDZUXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXDZUXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:23:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33099 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031499AbXDZUXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:23:20 -0400
Date: Thu, 26 Apr 2007 13:23:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
In-Reply-To: <46310216.2070608@shadowen.org>
Message-ID: <Pine.LNX.4.64.0704261320090.5678@schroedinger.engr.sgi.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
 <4630A662.8090502@shadowen.org> <4630ABF2.1040305@shadowen.org>
 <4630EBFA.9000207@shadowen.org> <Pine.LNX.4.64.0704261123080.3560@schroedinger.engr.sgi.com>
 <4630F203.7020005@shadowen.org> <Pine.LNX.4.64.0704261210430.7441@schroedinger.engr.sgi.com>
 <46310216.2070608@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Andy Whitcroft wrote:

> > Gcc 3.3 works just fine on other platforms like i386. This is more likely 
> > a platform issue. If we disable it then only for <= gcc 3.3 on ppc. If 
> > problems crop up with other platforms then we can expand on it.
> 
> I was thinking that it would be nasty to have a set of platform
> specific, compiler specific ifdefs in here.  I was more thinking of just
> making this a BUG for all platforms.  This does result in slightly later
> detection but this is a constant mode only, so any bad use of kmalloc()
> would be picked up on first boot in testing always.
> 
> I think that would be sufficient and safe even against the worst
> optimiser (none).  Plus much less horrible to look at?

The build time detection is quite important for NUMA since structures keep 
growing. I'd like to keep that. In fact I would really like a build time 
detection. If a too large kmalloc occurs then the compile should stop at 
that point and the kernel should not link at all.

See my patch @ http://marc.info/?l=linux-kernel&m=117752927203466&w=2

