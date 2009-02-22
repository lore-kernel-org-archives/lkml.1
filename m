Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZBVDOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZBVDOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 22:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZBVDOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 22:14:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZBVDOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 22:14:00 -0500
Message-ID: <49A0C2D4.20009@zytor.com>
Date: Sat, 21 Feb 2009 19:13:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] kmemcheck: disable fast string operations on P4 CPUs
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com> <1235223364-2097-2-git-send-email-vegard.nossum@gmail.com>
In-Reply-To: <1235223364-2097-2-git-send-email-vegard.nossum@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> This patch may allow us to remove the REP emulation code from
> kmemcheck.

> +#ifdef CONFIG_KMEMCHECK
> +	/*
> +	 * P4s have a "fast strings" feature which causes single-
> +	 * stepping REP instructions to only generate a #DB on
> +	 * cache-line boundaries.
> +	 *
> +	 * Ingo Molnar reported a Pentium D (model 6) and a Xeon
> +	 * (model 2) with the same problem.
> +	 */
> +	if (c->x86 == 15) {

If this is supposed to refer to the Intel P4 core, you should exclude
the post-P4 cores that also have x86 == 15 (e.g. Core 2 and Core i7).
If those are affected, too, they should be mentioned in the comment.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

