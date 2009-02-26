Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbZBZFdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbZBZFdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZBZFdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:33:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43868 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbZBZFdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:33:09 -0500
Date: Thu, 26 Feb 2009 06:32:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove update_apic from x86_quirks
Message-ID: <20090226053254.GA11806@elte.hu>
References: <49A61FA9.5080706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A61FA9.5080706@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: cleanup
> 
> x86_quirks->update_apic() calling looks crazy. so try to remove it
> 1. every apic take wakeup_cpu member directly
> 2. seperate es7000_apic to es7000_apic_cluster
> 3. use uv_wakeup_cpu directly
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/apic.h           |    7 +
>  arch/x86/include/asm/setup.h          |    3 
>  arch/x86/include/asm/uv/uv.h          |    3 
>  arch/x86/kernel/apic/apic_flat_64.c   |    4 -
>  arch/x86/kernel/apic/bigsmp_32.c      |    2 
>  arch/x86/kernel/apic/es7000_32.c      |  127 ++++++++++++++++++++++++++--------
>  arch/x86/kernel/apic/numaq_32.c       |   10 --
>  arch/x86/kernel/apic/probe_32.c       |   16 ----
>  arch/x86/kernel/apic/probe_64.c       |    3 
>  arch/x86/kernel/apic/summit_32.c      |    2 
>  arch/x86/kernel/apic/x2apic_cluster.c |    2 
>  arch/x86/kernel/apic/x2apic_phys.c    |    2 
>  arch/x86/kernel/apic/x2apic_uv_x.c    |   11 +-
>  arch/x86/kernel/setup.c               |   14 ---
>  arch/x86/kernel/smpboot.c             |    8 --
>  15 files changed, 121 insertions(+), 93 deletions(-)

that's certainly a nice cleanup! Applied to tip:x86/apic, thanks 
Yinghai!

	Ingo
