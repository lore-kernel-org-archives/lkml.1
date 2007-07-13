Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXGMQeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXGMQeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbXGMQeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:34:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39521 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760214AbXGMQeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:34:04 -0400
Date: Fri, 13 Jul 2007 09:34:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: ak@suse.de, linux-kernel@vger.kernel.org, travis@sgi.com, jeremy@goop.org
Subject: Re: x86: Convert cpu_core_map to be a per cpu variable
In-Reply-To: <20070713.000814.102125147.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0707130933140.21777@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
 <20070713.000814.102125147.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, David Miller wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Thu, 12 Jul 2007 23:58:06 -0700 (PDT)
> 
> > cpu_core_map is currently an array defined using NR_CPUS. This means that
> > we overallocate since we will rarely really use the maximum 
> > number of configured cpus. This may become a problem when we need to 
> > increase the NR_CPUs on x86_64 for our new product line.
> 
> I'm using NR_CPUS set to 1024 on my sparc64 workstation, it's
> not that bad to be honest :-)  What kind of cpu arity are you
> talking about?

Up to 16k.

> > If we put the cpu_core_map into the per cpu area then it will be allocated
> > for each processor as it comes online.
> > 
> > However, this means that the core map cannot be accessed until the per cpu 
> > area has been allocated. Xen does a weird thing here looping over all 
> > processors and zeroing the masks that are not yet allocated and that will 
> > be zeroed when they are allocated. I commented the code out. Maybe there 
> > is another purpose? Jeremy?
> > 
> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Please take care of sparc64 if you're going to do this change.
> It uses cpu_core_map too.

But the code modified here is x86_64 and i386 specific? Is there an 
overlap?

