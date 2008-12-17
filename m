Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759839AbYLQJp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbYLQJp7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYLQJps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:45:48 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52350 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbYLQJpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:45:47 -0500
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081216193648.GJ6681@linux.vnet.ibm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182659.30323.43898.stgit@pc1117.cambridge.arm.com>
	 <20081216193648.GJ6681@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 17 Dec 2008 09:44:56 +0000
Message-Id: <1229507096.32517.8.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2008 09:44:58.0119 (UTC) FILETIME=[1F90F170:01C9602C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 11:36 -0800, Paul E. McKenney wrote:
> On Wed, Dec 10, 2008 at 06:26:59PM +0000, Catalin Marinas wrote:
> > This patch adds the base support for the kernel memory leak
> > detector. It traces the memory allocation/freeing in a way similar to
> > the Boehm's conservative garbage collector, the difference being that
> > the unreferenced objects are not freed but only shown in
> > /sys/kernel/debug/memleak. Enabling this feature introduces an
> > overhead to memory allocations.
> 
> Looks good to me from an RCU viewpoint!
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks for reviewing it.

FYI, in the version I'm going to post this week I added another mutex to
ensure the exclusive opening of the /sys/kernel/debug/memleak file as
one can now use this file to configure kmemleak at run-time. The RCU
locking isn't affected and I'll add your "Reviewed-by:" line.

-- 
Catalin

