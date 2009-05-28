Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZE1DJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZE1DJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZE1DJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:09:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48510 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZE1DJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:09:17 -0400
Message-ID: <4A1DFD7B.3040901@zytor.com>
Date: Wed, 27 May 2009 19:56:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Harald Welte <HaraldWelte@viatech.com>
CC: lkml@morethan.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: LOCK prefix on uni processor has its use (was Re: [BUG FIX] Make
 x86_32 uni-processor Atomic ops, Atomic)
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com> <20090527170118.GC4024@prithivi.gnumonks.org>
In-Reply-To: <20090527170118.GC4024@prithivi.gnumonks.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Welte wrote:
> * A read-modify-write sequence cannot be interupted.
> * All X86 instructions except rep-strings are atomic wrt interrupts.
> * The lock prefix has uses on a UP processor: It keeps DMA devices from
>   interfering with a read-modify-write sequence

Correct.

> Now the question is: Is this a valid operation of a driver?  Should the driver
> do such things, or is such a driver broken?  When would that occur?  I'm trying
> to come up with a case, but typically you e.g. allocate some DMA buffer and
> then don't touch it until the hardware has processed it.

The Linux driver model does not permit this as a *lot* of hardware
doesn't support this correctly, and even on x86 there are lots of
chipset bugs in this regard.  It is of course possible to write x86-only
drivers that would do this anyway, but those should not use LOCK_PREFIX
instructions.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

