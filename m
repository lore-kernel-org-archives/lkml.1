Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYBDNCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYBDNCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYBDNCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:02:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45549 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbYBDNCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:02:10 -0500
Date: Mon, 4 Feb 2008 14:01:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: jikos@suse.cz, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: brk randomization breaks columns
Message-ID: <20080204130156.GA8730@elte.hu>
References: <20080204122837.GA1647@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204122837.GA1647@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Hmm, code in binfmt_elf is really strange.
> 
>         elf_bss += load_bias;
>         elf_brk += load_bias;
>         start_code += load_bias;
>         end_code += load_bias;
>         start_data += load_bias;
>         end_data += load_bias;
> 
>         /* Calling set_brk effectively mmaps the pages that we need
>          * for the bss and break sections.  We must do this before
>          * mapping in the interpreter, to make sure it doesn't wind
>          * up getting placed where the bss needs to go.
>          */
>         retval = set_brk(elf_bss, elf_brk);
> 
> ... so we allocate non-randoimzed brk, but later we just overwrite bss 
> variable with new, shiner and better randomized value... without 
> unmapping the old one... The code in binfmt_elf.c is really a mess.

hm, so it seems that it isnt even the randomization that causes the 
problem - but somehow the randomization code itself is broken, right? 

Would you be interested in figuring out how to unbreak this? [if not, 
could you send me the binary?]

	Ingo
