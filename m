Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbXFVRlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbXFVRlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbXFVRll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:41:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37096 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752933AbXFVRlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:41:40 -0400
Date: Fri, 22 Jun 2007 10:41:38 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@linux.vnet.ibm.com
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, akpm@linux-foundation.org
Subject: Re: cpuset attach_task to touch per-cpu kernel threads?
Message-Id: <20070622104138.9c23e1f1.pj@sgi.com>
In-Reply-To: <20070622171634.GA21543@linux.vnet.ibm.com>
References: <20070621014935.GF10980@linux.vnet.ibm.com>
	<20070621121635.GB19811@elte.hu>
	<20070621100712.52a4784a.pj@sgi.com>
	<20070621173232.GP10980@linux.vnet.ibm.com>
	<20070621105152.8daf87ad.pj@sgi.com>
	<20070622171634.GA21543@linux.vnet.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa wrote:
> That again is not fool-proof. What if kernel-tasks change their cpu affinity
> after we have done the is_pinned_kernel_thread() test? Ideally they
> should not, but one never knows!
> 
> IMHO we simply should not allow kernel threads to move out of top-cpuset

Well ... in some theoretical world, perhaps.

In reality, there a big pile of kernel threads that we want to move out
of the root cpuset.  And in reality, kernel threads don't change from
being unrestricted (all cpus allowed) to being pinned (to some specific
subset of cpus).  Kernel threads that need to be pinned know it up
front; it's an essential part of whatever they do.

I've been working with installed customer configurations for about two
and a half years now that move unpinned kernel threads out of the top
cpuset, as part of keeping portions of the system freed up for dedicated
jobs.  I cannot agree to removing this capability.

Nack.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
