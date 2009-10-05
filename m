Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZJESgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZJESgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZJESgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:36:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49496 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbZJESgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:36:17 -0400
Date: Mon, 5 Oct 2009 20:35:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use near online node instead of round bin for numa
Message-ID: <20091005183539.GR1656@one.firstfloor.org>
References: <4AC7974C.20304@kernel.org> <87my45yk79.fsf@basil.nowhere.org> <4ACA3677.40407@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACA3677.40407@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 11:09:59AM -0700, Yinghai Lu wrote:
> Andi Kleen wrote:
> > Yinghai Lu <yinghai@kernel.org> writes:
> > 
> >> cpu to node mapping is set in following sequence:
> >> 1. numa_init_array: set up roundbin from cpu to online node
> >> 2. init_cpu_to_node: set that according to apicid_to_node[] according to srat
> >> 		  only handle that node is online, and leave other cpu on node
> >> 		  without ram (aka not online) to still round-bin
> >> 3. later srat_detect_node for intel/amd, will use first_online node or near by
> >>    node.
> >>
> >> problem is that setup_per_cpu_areas() is called between  2 and 3. the per_cpu
> >> for cpu on node with ram is on different node. and could put that on node with
> >> two hops away.
> >>
> >> so try add find_near_online_node() and call int init_cpu_to_node()
> > 
> > This fallback case should not really happen anyways, unless the BIOS is buggy
> > (in this case it might better to completely reject the SRAT because
> > more might be wrong).
> SRAT is right, and some node has no ram installed.

In this case there should be still a PXM to define the CPU locality -- your BIOS is broken.
Please fix it there.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
