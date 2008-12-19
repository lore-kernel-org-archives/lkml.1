Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYLSLcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYLSLcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 06:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYLSLbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 06:31:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55169 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbYLSLbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 06:31:47 -0500
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: revert CONFIG_RELOCATABLE=y defconfig change
From: Andi Kleen <ak@halobates.de>
References: <20081218173506.GA29781@localhost.localdomain>
Date: Fri, 19 Dec 2008 12:32:27 +0100
In-Reply-To: <20081218173506.GA29781@localhost.localdomain> (Vegard Nossum's message of "Thu, 18 Dec 2008 18:35:06 +0100")
Message-ID: <87vdtgz9h0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum <vegard.nossum@gmail.com> writes:

> From 37a92bc970ce025d8a42fed27413485fd341db31 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Thu, 18 Dec 2008 18:03:20 +0100
> Subject: [PATCH] x86: revert CONFIG_RELOCATABLE=y defconfig change
>
> This commit:
>
> commit 5cb04df8d3f03e37a19f2502591a84156be71772
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Sun May 4 19:49:04 2008 +0200
>
>    x86: defconfig updates
>
> changed CONFIG_RELOCATABLE from n to y, which may lead to a mismatch
> between the vmlinux debug information and the runtime location of the
> kernel, even when the bootloader does not relocate the kernel.
>
> Revert the specific change. Works for me with GRUB and qemu.
>
> Reference: http://lkml.org/lkml/2008/11/25/243

it would be better to find some way to fix up the debug information
(perhaps this can be done with the right ld parameters?)

Changing defconfig doesn't really fix the problem because there will
be still lots of kernel configurations around with
CONFIG_RELOCATABLE=y

-Andi

-- 
ak@linux.intel.com
