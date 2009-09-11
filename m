Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZIKJ3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZIKJ3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZIKJ3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:29:33 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47577 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbZIKJ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:29:33 -0400
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [2.6.31] Memory leak in load_module()?
References: <200909111638.IDC17135.FOHJOtFFMQSVLO@I-love.SAKURA.ne.jp>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 11 Sep 2009 10:29:25 +0100
In-Reply-To: <200909111638.IDC17135.FOHJOtFFMQSVLO@I-love.SAKURA.ne.jp> (Tetsuo Handa's message of "Fri\, 11 Sep 2009 16\:38\:46 +0900")
Message-ID: <tnxhbv97rt6.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Sep 2009 09:29:26.0761 (UTC) FILETIME=[5B23FD90:01CA32C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> I changed CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE to 2000 and did
>
> # insmod /lib/modules/2.6.31/kernel/drivers/edac/r82600_edac.ko
> insmod: error inserting '/lib/modules/2.6.31/kernel/drivers/edac/r82600_edac.ko': -1 Unknown symbol in module
> # echo scan > /sys/kernel/debug/kmemleak
> # dmesg
> r82600_edac: Unknown symbol edac_mc_del_mc
> r82600_edac: Unknown symbol edac_mc_add_mc
> r82600_edac: Unknown symbol edac_pci_create_generic_ctl
> r82600_edac: Unknown symbol edac_mc_alloc
> r82600_edac: Unknown symbol edac_mc_find_csrow_by_page
> r82600_edac: Unknown symbol edac_mc_free
> r82600_edac: Unknown symbol edac_mc_handle_ce
> r82600_edac: Unknown symbol edac_mc_handle_ue
> r82600_edac: Unknown symbol edac_pci_release_generic_ctl
> kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> # tail -n 4 /sys/kernel/debug/kmemleak
> unreferenced object 0xd643a788 (size 32):
>   comm "insmod", pid 2854, jiffies 4294791099
>   backtrace:
>     [<ffffffff>] 0xffffffff
>
> Is this real memory leak?

It could be but isn't stack tracing enabled on your system? The
backtrace doesn't seem very useful.

-- 
Catalin
