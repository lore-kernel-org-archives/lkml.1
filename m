Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYIVSFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYIVSFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYIVSFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:05:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:25164 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbYIVSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ngs/wAOpuf6M9lILrNSje1no7o5y5RfmFtXQtUhjD63b4Eh/s+uqxKDazGLtKJQERB
         5eiRnwoo7733X1rmsI89zPJ2pR57LGzgMzeclXH5nrubyAIPXchLWWohQnOKis/mmoAD
         Ku3vjul/CVFVral9MrZmUIuU3+j/bdxgr0v98=
Date: Mon, 22 Sep 2008 22:05:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       dzickus@redhat.com, prarit@redhat.com, vgoyal@redhat.com
Subject: Re: [PATCH] NMI watchdog: setup before enabling NMI watchdog
Message-ID: <20080922180535.GB22024@localhost>
References: <20080922171347.GI16840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922171347.GI16840@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Aristeu Rozanski - Mon, Sep 22, 2008 at 01:13:59PM -0400]
| There's a small window when NMI watchdog is being set up that if any NMIs
| are triggered, the NMI code will make make use of not initalized wd_ops
| elements:

Hi Aristeu,

thanks for the patch! I may be _absolutely_ wrong but could you
explain me how we reach this site in traps

---
	if (!(reason & 0xc0)) {
		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason,
				2, SIGINT) == NOTIFY_STOP)
			return;
		/*
		 * Ok, so this is none of the documented NMI sources,
		 * so it must be the NMI watchdog.
			 ^^^^
		 */
		if (nmi_watchdog_tick(regs, reason))
			return;
		if (!do_nmi_callback(regs, cpu))
			unknown_nmi_error(reason, regs);

		return;
	}
---

not having masked APIC registers as NMI entry yet (which is done during
perfctl initialization)?

		- Cyrill -
