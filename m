Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbZE0SIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbZE0SIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762171AbZE0SI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:08:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36277 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913AbZE0SI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:08:28 -0400
To: Harald Welte <HaraldWelte@viatech.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml@morethan.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: LOCK prefix on uni processor has its use
From: Andi Kleen <andi@firstfloor.org>
References: <200905221139.26941.lkml@morethan.org>
	<200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com>
	<200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com>
	<20090527170118.GC4024@prithivi.gnumonks.org>
Date: Wed, 27 May 2009 20:08:27 +0200
In-Reply-To: <20090527170118.GC4024@prithivi.gnumonks.org> (Harald Welte's message of "Wed, 27 May 2009 19:01:18 +0200")
Message-ID: <87vdnmmnac.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Welte <HaraldWelte@viatech.com> writes:
> * All X86 instructions except rep-strings are atomic wrt interrupts.
> * The lock prefix has uses on a UP processor: It keeps DMA devices from
>   interfering with a read-modify-write sequence

In theory yes, but not in Linux -- normal drivers simply don't use LOCK in any way
on a UP kernel.

We discussed exactly this in the earlier subthread :)

> Now the question is: Is this a valid operation of a driver?  Should the driver
> do such things, or is such a driver broken? 

The driver is broken because if it relies on this it will not work on a UP kernel.
Also it's not portable and in general a bad idea.

> When would that occur?  I'm trying
> to come up with a case, but typically you e.g. allocate some DMA buffer and
> then don't touch it until the hardware has processed it.

Is it known which driver has this problem?

-Andi (who finds hpa's "timing theory" to be more believable anyways)

-- 
ak@linux.intel.com -- Speaking for myself only.
