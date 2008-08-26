Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbYHZU3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbYHZU3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYHZU27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:28:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYHZU26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:28:58 -0400
Date: Tue, 26 Aug 2008 22:28:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
Message-ID: <20080826202832.GB16072@elte.hu>
References: <200808262057.51606.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808262057.51606.agruen@suse.de>
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


* Andreas Gruenbacher <agruen@suse.de> wrote:

> +++ b/kernel/sched.c
> @@ -8149,6 +8149,15 @@ void __init sched_init(void)
>  	plist_head_init(&init_task.pi_waiters, &init_task.pi_lock);
>  #endif
>  
> +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> +	/*
> +	 * Because of the reduced scope of CAP_SETPCAP when filesystem
> +	 * capabilities are in effect, it is safe to allow CAP_SETPCAP to
> +	 * be available in the default configuration.
> +	 */
> +	init_task.cap_bset = CAP_FULL_SET;
> +#endif

hm, this doesnt belong into sched.c. You need your own (ifdef-less) init 
function in init/main.c or so.

	Ingo
