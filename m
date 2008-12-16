Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbYLPLK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbYLPLK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYLPLKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:10:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51359 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYLPLKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:10:10 -0500
Date: Tue, 16 Dec 2008 12:09:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Huang Ying <ying.huang@intel.com>, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kdump hangs up by Sysrq+C trigger in high load.
Message-ID: <20081216110949.GB4299@elte.hu>
References: <20081216152143.88caba51.ytakahashi@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216152143.88caba51.ytakahashi@miraclelinux.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yoshihiro Takahashi <ytakahashi@miraclelinux.com> wrote:

> Hi.
> 
> kdump hangs up by Sysrq+C trigger once in about 10 times in high load. 
> After the above occurs, kdump cannot collect vmcores with NMI button. 
> When waiting_for_crash_ipi does case more than 0, mdelay seem to make a 
> stall.
> 
> While nmi_shootdown_cpus(), mdelay may not work since interruption is 
> disable.  (ex. when crashing kernel by NMI interruption, all 
> interruption may be disabled.).
> 
> So I think that it should use other way (TSC) instead of mdelay() in 
> nmi_shootdown_cpus().

mdelay uses either the tsc or CPU loops - neither stop while IRQs are 
disabled.

Could you figure out exactly why it hangs in your case?

	Ingo
