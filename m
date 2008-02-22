Return-Path: <linux-kernel-owner+w=401wt.eu-S934141AbYBVMZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbYBVMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYBVMZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:25:21 -0500
Received: from mail.suse.de ([195.135.220.2]:38967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbYBVMZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:25:19 -0500
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box
From: Andi Kleen <andi@firstfloor.org>
References: <200802210258.45011.yinghai.lu@sun.com>
Date: Fri, 22 Feb 2008 13:25:18 +0100
In-Reply-To: <200802210258.45011.yinghai.lu@sun.com> (Yinghai Lu's message of "Thu\, 21 Feb 2008 02\:58\:44 -0800")
Message-ID: <p73hcg189g1.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <Yinghai.Lu@Sun.COM> writes:

> quad core 8 socket system will have apic id lifting.the apic id range could
> be [4, 0x23]. or [8, 0x27]. apic_is_clustered_box will think that need to three clusters
> and that is large than 2. So it is treated as clustered_box.
>
> and will get
>
> Marking TSC unstable due to TSCs unsynchronized
>
> even the CPUs have X86_FEATURE_CONSTANT_TSC set.
>
> this patch offset back the apic before get apic clusterid.
>
> or use dmi to get apic_is_clustered?

The clustered check is for Summit and es7000 systems
On 64bit systems it might be actually possible to trigger
this based on SLIT instead. But you'll need to check with
the IBM Summit/Unisys es7000 developers if that works or not

If you don't want to do that the safer way would be probably
the check if there are holes between the CPUs APIC numbers.
If yes then it's likely clustered mode. I think that would
be better than to disable it unconditionally for apic lifting
like your patches does.

-Andi
