Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbZFBHy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbZFBHy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbZFBHys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:54:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59345 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759859AbZFBHyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:54:47 -0400
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC patch] reset TSC at the begining of check_tsc_warp
From: Andi Kleen <andi@firstfloor.org>
References: <3877989d0906010201j438a08a8x559f62b0aed40696@mail.gmail.com>
Date: Tue, 02 Jun 2009 09:54:44 +0200
In-Reply-To: <3877989d0906010201j438a08a8x559f62b0aed40696@mail.gmail.com> (Luming Yu's message of "Mon, 1 Jun 2009 17:01:53 +0800")
Message-ID: <87my8rcbp7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luming Yu <luming.yu@gmail.com> writes:

> Hello,
>
> Without this patch, we always get kernel warning that TSC warp between CPUs,
> and TSC is marked unstable due to check_tsc_sync_source failed if the CPUs
> have the problem of not-synced initial TSC.
>
> It hurts CPUs with constant-tsc feature, but with unsynced initial TSC value...
>
> The downside is we could break perfect synced TSC with this patch.

s/could/will definitely/

So you're hurting the good systems for one buggy box. I don't think
that's a good idea.

Possible alternatives:
- black list that system with DMI
- try to detect it by checking constant_tsc and still unsynchronized TSC
- just give up and say the system won't be able to use TSC unless the BIOS
fixes its act.

The third option is probably not the worst.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
