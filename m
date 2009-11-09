Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZKIILE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZKIILE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZKIILD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:11:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbZKIILC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:11:02 -0500
Date: Mon, 9 Nov 2009 09:10:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: tip tree build warning
Message-ID: <20091109081038.GJ453@elte.hu>
References: <20091028181443.50a09dbb.sfr@canb.auug.org.au>
 <20091028073145.GD6353@elte.hu>
 <20091028184126.b5f52d1b.sfr@canb.auug.org.au>
 <20091028184851.504752ef.sfr@canb.auug.org.au>
 <20091028075012.GD19402@elte.hu>
 <20091108213055.GA13555@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108213055.GA13555@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> +++ linux-2.6.git/arch/x86/include/asm/apic.h
> @@ -310,7 +310,7 @@ struct apic {
>  	int (*apicid_to_node)(int logical_apicid);
>  	int (*cpu_to_logical_apicid)(int cpu);
>  	int (*cpu_present_to_apicid)(int mps_cpu);
> -	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
> +	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *map);

Yep, passing masks by reference is unconditonal goodness - that's the 
cleanup we want.

Mind sending a delta patch against tip:master?

	Ingo
