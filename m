Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYIVSt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYIVSt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYIVSsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:48:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:1551 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbYIVSsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UG4Vc36vbIMTrU096IiuNLKpeMlvnSALF/QmotLSy67G1Wga93+By5jIiDFcd+xP+U
         zHMI1AGd3yZA4d4nnQJdBE0xGrtVZ+M6+4wBlaNsQZRnDWxS//F7pUmO72yMPOA4ivYm
         iaLgaIfVhcS8jY8Yr9fOWtHAzgujOgFHLNhXQ=
Date: Mon, 22 Sep 2008 22:48:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       dzickus@redhat.com, prarit@redhat.com, vgoyal@redhat.com
Subject: Re: [PATCH] NMI watchdog: setup before enabling NMI watchdog
Message-ID: <20080922184854.GC22024@localhost>
References: <20080922171347.GI16840@redhat.com> <20080922180535.GB22024@localhost> <20080922183504.GN16840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922183504.GN16840@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Aristeu Rozanski - Mon, Sep 22, 2008 at 02:35:05PM -0400]
| > Hi Aristeu,
| > 
| > thanks for the patch! I may be _absolutely_ wrong but could you
| > explain me how we reach this site in traps
| > 
| > ---
| > 	if (!(reason & 0xc0)) {
| > 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason,
| > 				2, SIGINT) == NOTIFY_STOP)
| > 			return;
| > 		/*
| > 		 * Ok, so this is none of the documented NMI sources,
| > 		 * so it must be the NMI watchdog.
| > 			 ^^^^
| > 		 */
| > 		if (nmi_watchdog_tick(regs, reason))
| > 			return;
| > 		if (!do_nmi_callback(regs, cpu))
| > 			unknown_nmi_error(reason, regs);
| > 
| > 		return;
| > 	}
| > ---
| > 
| > not having masked APIC registers as NMI entry yet (which is done during
| > perfctl initialization)?
| actually the comment is a bit misleading. we can get other "undocumented"
| NMIs from different sources. Notice that if the nmi_watchdog_tick() doesn't
| identifies it as a performance counter generated NMI (if LAPIC based, IOAPIC
| always assume that the NMI is for the NMI watchdog), a default NMI callback
| will be tried and if it fails, unknown_nmi_error() will be called. The first
| case comes to my head is those NMI buttons present on development machines.
| 
| -- 
| Aristeu
| 

Thanks Aristeu!

		- Cyrill -
