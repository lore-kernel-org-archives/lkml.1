Return-Path: <linux-kernel-owner+w=401wt.eu-S1764316AbXHHWXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764316AbXHHWXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbXHHWXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:23:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758012AbXHHWXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:23:35 -0400
Date: Thu, 9 Aug 2007 00:23:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: gdavis@mvista.com, linux-kernel@vger.kernel.org
Subject: Re: -
	fix-local_irq_-macro-definition-thinkos-for-the-trace_irqflags_support-case.patch
	removed from -mm tree
Message-ID: <20070808222322.GB16238@elte.hu>
References: <200708082117.l78LHgL9030537@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708082117.l78LHgL9030537@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> This patch was dropped because it had testing failures

> -# define raw_local_irq_disable()	local_irq_disable()
> -# define raw_local_irq_enable()		local_irq_enable()
> -# define raw_local_irq_save(flags)	local_irq_save(flags)
> -# define raw_local_irq_restore(flags)	local_irq_restore(flags)
> +# define local_irq_disable()		raw_local_irq_disable()
> +# define local_irq_enable()		raw_local_irq_enable()
> +# define local_irq_save(flags)		raw_local_irq_save(flags)
> +# define local_irq_restore(flags)	raw_local_irq_restore(flags)
>  #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */

hm, indeed: an #ifdef LOCKDEP_SUPPORT has to be added around these 4 
macros. That will make this build fine on non-lockdep architectures too. 
Sorry, i should have noticed this!

	Ingo
