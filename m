Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbYJKIeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbYJKIeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 04:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYJKIeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 04:34:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYJKIeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 04:34:05 -0400
Date: Sat, 11 Oct 2008 10:33:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andy Henroid <andrew.d.henroid@intel.com>,
       Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 53/85] i7300_idle driver v1.55
Message-ID: <20081011083347.GA31918@elte.hu>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com> <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Len,

* Len Brown <lenb@kernel.org> wrote:

> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -62,6 +62,13 @@ void idle_notifier_register(struct notifier_block *n)
>  {
>  	atomic_notifier_chain_register(&idle_notifier, n);
>  }
> +EXPORT_SYMBOL_GPL(idle_notifier_register);
> +
> +void idle_notifier_unregister(struct notifier_block *n)
> +{
> +	atomic_notifier_chain_unregister(&idle_notifier, n);
> +}
> +EXPORT_SYMBOL_GPL(idle_notifier_unregister);

hm, such x86 infrastructure changes should be submitted via the x86 
tree, and you should at least have Cc:-ed the maintainers.

The thing is, we are _getting rid_ of the idle notifiers, not extending 
them. The last thing we need is random opaque stuff getting called in 
weird ordering when we enter/exit idle state. We want all that be 
visible and have explicit, in-source-code ordering.

	Ingo
