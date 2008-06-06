Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYFFNQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYFFNQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYFFNPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:15:46 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:49235 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbYFFNPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:15:41 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>, Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATED] x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.
From: Andi Kleen <andi@firstfloor.org>
References: <4848046A.5060006@goop.org> <484823BD.76E4.0078.0@novell.com>
	<484901A3.3040401@goop.org>
Date: Fri, 06 Jun 2008 15:15:37 +0200
In-Reply-To: <484901A3.3040401@goop.org> (Jeremy Fitzhardinge's message of "Fri, 06 Jun 2008 10:21:39 +0100")
Message-ID: <87lk1iu2km.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jun 2008 13:08:29.0113 (UTC) FILETIME=[69BF4290:01C8C7D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> When a 64-bit x86 processor runs in 32-bit PAE mode, a pte can
> potentially have the same number of physical address bits as the
> 64-bit host ("Enhanced Legacy PAE Paging").  This means, in theory,
> we could have up to 52 bits of physical address in a pte.
>
> The 32-bit kernel uses a 32-bit unsigned long to represent a pfn.
> This means that it can only represent physical addresses up to 32+12=44
> bits wide.  Rather than widening pfns everywhere, just set 2^44 as the
> Linux x86_32-PAE architectural limit for physical address size.

43bits might be actally safer because of potential sign bugs.

But of course it won't work anyways likely.

-Andi
