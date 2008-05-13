Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbYEMMpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbYEMMpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYEMMpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:45:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbYEMMpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:45:11 -0400
Date: Tue, 13 May 2008 14:44:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] x86: janitor work in bugs.c
Message-ID: <20080513124454.GF14973@elte.hu>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org> <fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0104]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Vajna <vmiklos@frugalware.org> wrote:

> -		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
> +		printk(KERN_EMERG "No coprocessor found and no math "
> +			"emulation present.\n");

generally we do not break up strings mid-stream - that makes grepping 
harder. _At most_ we do something like:

		printk(KERN_EMERG
		       "No coprocessor found and no math emulation present.\n");

> -/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
> +/* trap_init() enabled FXSR and company _before_ testing for FP problems
> + * here. */

that's not the proper multi-line comment style, this would be:

  /*
   * trap_init() enabled FXSR and company _before_ testing for
   * FP problems here.
   */

same for other places in this patch and for your next patch.

	Ingo
