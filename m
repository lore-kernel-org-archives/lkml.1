Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbYCCKjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbYCCKjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYCCKjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:39:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57265 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYCCKjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:39:45 -0500
Date: Mon, 3 Mar 2008 11:39:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303103933.GC21190@elte.hu>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303093103.GA23651@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> >From compiler-gcc.h:
> >
> > #define inline          inline          __attribute__((always_inline))
> 
> So unless I am missing something obvious then each time we say inline 
> to a function we require gcc to inline the function.
> 
> It is my impression that today we only say inline if really needed and 
> otherwise let gcc decide. So in almost all cases inlise should just be 
> nuked?

no, what we should nuke is this always_inline definition. That was 
always the intention of FORCED_INLINE, and the removal of FORCED_INLINE 
was to _remove the forcing_, not to make it unconditional.

so Adrian, if you knew about this bug all along, you might as well have 
reported it :-/

	Ingo
