Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZCFO76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZCFO76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZCFO7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:59:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41561 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbZCFO7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:59:49 -0500
Date: Fri, 6 Mar 2009 15:59:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state
Message-ID: <20090306145928.GE21907@elte.hu>
References: <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B0640A.5080607@kernel.org>
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

> Impact: cleanup
> 
> extend after_bootmem and after_init_bootmem to bootmem_state 
> and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM

Ok, that indeed makes all these bootstrap initialization details 
cleaner and more transparent.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/setup.c |    1 +
>  arch/x86/mm/init.c      |   13 +++++++------
>  arch/x86/mm/init_32.c   |   28 ++++++++++++++++++++--------
>  arch/x86/mm/init_64.c   |   33 +++++++++++++++++++--------------
>  include/linux/mm.h      |    8 ++++++++
>  5 files changed, 55 insertions(+), 28 deletions(-)

Note: "git grep after_bootmem" will show you another affected 
architecture as well.

> +++ linux-2.6/include/linux/mm.h
> @@ -1067,6 +1067,14 @@ extern void __init mmap_init(void);
>  extern void show_mem(void);
>  extern void si_meminfo(struct sysinfo * val);
>  extern void si_meminfo_node(struct sysinfo *val, int nid);
> +
> +enum bootmem_state_t {
> +	BEFORE_BOOTMEM = 0,

(nit: =0 is not required. )

> +	DURING_BOOTMEM,
> +	AFTER_BOOTMEM
> +};
> +extern enum bootmem_state_t bootmem_state;

(nit: we put newlines after enum definitions)

	Ingo
