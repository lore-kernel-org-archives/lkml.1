Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbYIVSfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbYIVSfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYIVSew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:34:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54930 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbYIVSew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:34:52 -0400
Date: Mon, 22 Sep 2008 14:35:05 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       dzickus@redhat.com, prarit@redhat.com, vgoyal@redhat.com
Subject: Re: [PATCH] NMI watchdog: setup before enabling NMI watchdog
Message-ID: <20080922183504.GN16840@redhat.com>
References: <20080922171347.GI16840@redhat.com> <20080922180535.GB22024@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922180535.GB22024@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Aristeu,
> 
> thanks for the patch! I may be _absolutely_ wrong but could you
> explain me how we reach this site in traps
> 
> ---
> 	if (!(reason & 0xc0)) {
> 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason,
> 				2, SIGINT) == NOTIFY_STOP)
> 			return;
> 		/*
> 		 * Ok, so this is none of the documented NMI sources,
> 		 * so it must be the NMI watchdog.
> 			 ^^^^
> 		 */
> 		if (nmi_watchdog_tick(regs, reason))
> 			return;
> 		if (!do_nmi_callback(regs, cpu))
> 			unknown_nmi_error(reason, regs);
> 
> 		return;
> 	}
> ---
> 
> not having masked APIC registers as NMI entry yet (which is done during
> perfctl initialization)?
actually the comment is a bit misleading. we can get other "undocumented"
NMIs from different sources. Notice that if the nmi_watchdog_tick() doesn't
identifies it as a performance counter generated NMI (if LAPIC based, IOAPIC
always assume that the NMI is for the NMI watchdog), a default NMI callback
will be tried and if it fails, unknown_nmi_error() will be called. The first
case comes to my head is those NMI buttons present on development machines.

-- 
Aristeu

