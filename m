Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbYARLEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbYARLEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759297AbYARLDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:03:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377AbYARLDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:03:05 -0500
Date: Fri, 18 Jan 2008 12:02:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
Message-ID: <20080118110252.GA17397@elte.hu>
References: <200801171643.49301.michael-lists@free-electrons.com> <478F8AEC.1080209@free-electrons.com> <1200590031.5332.19.camel@cinder.waste.org> <200801172315.29976.michael-lists@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801172315.29976.michael-lists@free-electrons.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Michael Opdenacker <michael-lists@free-electrons.com> wrote:

>  obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
> -obj-y				+= pcspeaker.o
> -
>  obj-$(CONFIG_SCx200)		+= scx200_32.o
>  
> +ifdef CONFIG_INPUT_PCSPKR
> +	obj-y			+= pcspeaker.o
> +endif

why didnt you make this:

  obj-$(CONFIG_INPUT_PCSPKR)		+= pcspeaker.o

?

Your patch looks fine to me otherwise, obviously if someone disables 
PCSPKR intentionally in the .config, the kernel should just do that. 
Could you resend it with the above thing fixed, and against x86.git#mm? 
The x86.git coordinates are at:

 http://redhat.com/~mingo/x86.git/README

	Ingo
