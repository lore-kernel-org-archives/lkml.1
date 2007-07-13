Return-Path: <linux-kernel-owner+w=401wt.eu-S935974AbXGMHIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935974AbXGMHIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbXGMHIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:08:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32858
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbXGMHIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:08:15 -0400
Date: Fri, 13 Jul 2007 00:08:14 -0700 (PDT)
Message-Id: <20070713.000814.102125147.davem@davemloft.net>
To: clameter@sgi.com
Cc: ak@suse.de, linux-kernel@vger.kernel.org, travis@sgi.com, jeremy@goop.org
Subject: Re: x86: Convert cpu_core_map to be a per cpu variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 12 Jul 2007 23:58:06 -0700 (PDT)

> cpu_core_map is currently an array defined using NR_CPUS. This means that
> we overallocate since we will rarely really use the maximum 
> number of configured cpus. This may become a problem when we need to 
> increase the NR_CPUs on x86_64 for our new product line.

I'm using NR_CPUS set to 1024 on my sparc64 workstation, it's
not that bad to be honest :-)  What kind of cpu arity are you
talking about?

> If we put the cpu_core_map into the per cpu area then it will be allocated
> for each processor as it comes online.
> 
> However, this means that the core map cannot be accessed until the per cpu 
> area has been allocated. Xen does a weird thing here looping over all 
> processors and zeroing the masks that are not yet allocated and that will 
> be zeroed when they are allocated. I commented the code out. Maybe there 
> is another purpose? Jeremy?
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

Please take care of sparc64 if you're going to do this change.
It uses cpu_core_map too.
