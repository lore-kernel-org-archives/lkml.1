Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYFTLjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYFTLjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYFTLjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:39:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60139 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYFTLjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:39:45 -0400
Date: Fri, 20 Jun 2008 13:39:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zach Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080620113922.GG7439@elte.hu>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com> <20080603182014.79a38d03@infradead.org> <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com> <20080604061637.6bab3f67@infradead.org> <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com>
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


* Alok Kataria <akataria@vmware.com> wrote:

>  		loops_per_jiffy = preset_lpj;
> -		printk("Calibrating delay loop (skipped)... "
> -			"%lu.%02lu BogoMIPS preset\n",
> -			loops_per_jiffy/(500000/HZ),
> -			(loops_per_jiffy/(5000/HZ)) % 100);
> +		printk(KERN_DEBUG "Calibrating delay loop skipped, "
> +				"using preset value.. ");

i dont think the message should be eliminated from default logs via 
making it KERN_DEBUG - this message is a common pattern people watch out 
for and it does give an indication about various sorts of 
timing/performance trouble.

also, if you break a line like hat i'd suggest to do it like this:

> +		printk(KERN_DEBUG
> +		  "Calibrating delay loop skipped, using preset value.. ");

so that the string remains on a single line.

	Ingo
