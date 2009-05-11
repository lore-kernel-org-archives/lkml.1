Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbZEKNWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbZEKNWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbZEKNWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:22:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41613 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZEKNWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:22:46 -0400
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       linux-numa@vger.kernel.org
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
From: Andi Kleen <andi@firstfloor.org>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
Date: Mon, 11 May 2009 15:22:44 +0200
In-Reply-To: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de> (Stefan Lankes's message of "Mon, 11 May 2009 10:27:18 +0200")
Message-ID: <87zldjn597.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Lankes <lankes@lfbs.rwth-aachen.de> writes:
>
> [Patch 1/4]: Extend the system call madvise with a new parameter
> MADV_ACCESS_LWP (the same as used in Solaris). The specified memory area

Linux does NUMA memory policies in mbind(), not madvise()
Also if there's a new NUMA policy it should be in the standard
Linux NUMA memory policy frame work, not inventing a new one

[I find it amazing that you did apparently so much work
without being familiar with existing Linux NUMA policies]

Your patches seem to have a lot of overlap with 
Lee Schermerhorn's old migrate memory on cpu migration patches.
I don't know the status of those.

> [Patch 4/4]: This part of the patch adds some counters to detect migration
> errors and publishes these counters via /proc/vmstat. Besides this, the
> Kconfig file is extend with the parameter CONFIG_AFFINITY_ON_NEXT_TOUCH.
>
> With this patch, the kernel reduces the overhead of page distribution via
> "affinity-on-next-touch" from 2518ms to 366ms compared to the user-level

The interesting part is less how much faster it is compared to an user
space implementation, but how much this migrate on touch approach
helps in general compared to already existing policies. Some hard
numbers on that would appreciated.

Note that for the OpenMP case old kernels sometimes had trouble because
the threads tended to be not scheduled to the final target CPU
on the first time slice so the memory was often first-touched
on the wrong node. Later kernels avoided that by more aggressively
moving the threads early.

This nearly sounds like a workaround for that (I hope it's more
than that)

If you present any benchmark make sure the kernel you're benching
against does not have this issue.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
