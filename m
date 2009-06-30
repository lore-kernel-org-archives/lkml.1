Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZF3UhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZF3UhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZF3UhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:37:04 -0400
Received: from 65-115-68-195.dia.static.qwest.net ([65.115.68.195]:39929 "EHLO
	chronus.3leafnetworks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752165AbZF3UhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:37:02 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2009 16:37:02 EDT
Date: Tue, 30 Jun 2009 13:21:53 -0700
From: Scott Lurndal <scott.lurndal@3leafsystems.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tj@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Message-ID: <20090630202153.GB28043@pendragon.3leafnetworks.com>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906301533400.29795@gentwo.org>
User-Agent: Mutt/1.4.2.2i
X-OriginalArrivalTime: 30 Jun 2009 20:21:54.0122 (UTC) FILETIME=[68A17AA0:01C9F9C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 03:39:52PM -0400, Christoph Lameter wrote:
> On Tue, 30 Jun 2009, Ingo Molnar wrote:
> 
> > Yeah, it's a bug for something like a virtual environment which
> > boots generic kernels that might have 64 possible CPUs (on a true
> > 64-way system), but which will have fewer in practice.
> 
> A machine (and a virtual environment) can indicate via the BIOS tables or
> ACPI that there are less "possible" cpus. That is actually very common.
> 
> The difference between actual and possible cpus only has to be the number
> of processors that could be brought up later. In a regular system that is
> pretty much zero. In a fancy system with actual hotpluggable cpus there
> would be a difference but usually the number of hotpluggable cpus is
> minimal.

A hypervisor running on a 4-socket Beckton platform will have 32
(without hyperthreading) or 64 (with hyperthreading) CPUs to
allocate 1Q2010.   A hypervisor supporting ACPI hot-plug would be able
then to hot-plug from one to 64 cores into a single linux guest if it
wanted to (and didn't overcommit, so gang-scheduling wasn't required).

Such a hypervisor might typically pass the maximum number of
CPUs in via the guest ACPI tables when the guest boots, to provide
the maximum flexibility in being able to grow and shrink the guest,
with only a subset marked as initially present.

I've been working recently with a 128 (shanghai) / 192 (istanbul)
core shared memory system which supports hot plugging CPUs into Linux,
and the feature would be less useful if a hot-plug event could fail
because the per-cpu area couldn't be allocated at the time of the
event (which argues for pre-allocation, if a large physically contiguous
region is required).

That said, I don't see much use for 32-bit kernels in environments with
such CPU counts.

scott
