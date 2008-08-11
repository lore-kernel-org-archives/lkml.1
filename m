Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYHKTKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYHKTKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYHKTK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:10:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37527 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYHKTK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:10:28 -0400
Date: Mon, 11 Aug 2008 21:10:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
Message-ID: <20080811191012.GA16553@elte.hu>
References: <489A1844.3090502@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489A1844.3090502@am.sony.com>
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


* Tim Bird <tim.bird@am.sony.com> wrote:

> Add support for a built-in command line for x86 architectures. The 
> Kconfig help gives the major rationale for this addition.

i have actually used a local hack quite similar to this to inject boot 
options into bzImages via randconfig - so i would find this feature 
rather useful.

a small observation:

> +	/* append boot loader cmdline to builtin, unless builtin overrides it */
> +	if (builtin_cmdline[0] != '!') {
> +		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
> +		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
> +		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> +	} else {
> +		strlcpy(boot_command_line, &builtin_cmdline[1],
> +			COMMAND_LINE_SIZE);
> +	}

the default branch changes existing command lines slightly: it appends a 
space to them. This could break scripts that rely on the precise 
contents of /proc/cmdline output. (i have some - they are arguably 
dodgy)

Best would be to make it really apparent in the code that nothing 
changes if this config option is not set. Preferably there should be no 
extra code at all in that case.

	Ingo
