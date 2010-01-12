Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265Ab0ALU7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0ALU7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 15:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467Ab0ALU67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 15:58:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022Ab0ALU67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 15:58:59 -0500
Date: Tue, 12 Jan 2010 12:57:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] use nr_cpus= to set nr_cpu_ids early
In-Reply-To: <alpine.DEB.2.00.1001121436080.25925@router.home>
Message-ID: <alpine.LFD.2.00.1001121254160.17145@localhost.localdomain>
References: <1263298146-25597-1-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001121436080.25925@router.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Jan 2010, Christoph Lameter wrote:
>
> Trouble is that NR_CPUS is used all over the place. If nr_cpu_ids < 
> NR_CPUS at boot then there is a danger of for loops to NR_CPUS going out 
> of bounds.
> 
> CONFIG_NR_CPUS is used for various bitmaps so that seems to be okay.
> 
> drivers/acpi/numa.c:acpi_numa_init probably should use nr_cpu_ids 
> instead now.
> 
> There is an octeon driver in staging that has some issues with NR_CPUS 
> as well.

I suspect that this is the real reason for the current behavior of 
'maxcpus=', and that if all of those issues get fixed we could probably 
make maxcpus do what Yinghai's new 'nr_cpus=' does.

So in a perfect world, CONFIG_NR_CPUS's would never really be used, except 
for some fundamental static allocations/limits that are too painful to try 
to make dynamic.

I doubt that anybody really _cares_ about the "you can add them later" 
behavior of the current maxcpus thing, and I suspect that the nr_cpus 
semantics is what people generally would have expected.

			Linus
