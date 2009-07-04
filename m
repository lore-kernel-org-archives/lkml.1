Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZGDK3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZGDK3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZGDK3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:29:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZGDK3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:29:14 -0400
Date: Sat, 4 Jul 2009 12:29:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Boot Consoles question...
Message-ID: <20090704102904.GB32257@elte.hu>
References: <200907040017.26921.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907040017.26921.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> Quick question...
> 
> In register_console()
> 
>         if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == 
> CON_CONSDEV)) {
> 		[[snip]]
>                 newcon->flags &= ~CON_PRINTBUFFER;
>         }
> 
> So - when we are switching over from a boot console to a "real" 
> console - we don't back up the console, and print everything out.
> 
> This means that the boot console is on a different device than 
> that "real" console - you don't actually see the full boot message 
> (from log_start) on the "real" console.
> 
> Is this what is intended (that the boot message gets split into 2 
> - 1/3 going into the bootconsole - and the remaining to to the 
> real console?)
> 
> I can understand this when both (boot and real) are the same 
> device (serial) or vga, but where they are not - it is a little 
> confusing to the user - isn't it?

Could be changed i guess ... but is it really an issue? All messages 
should be in the syslog buffer (if it's large enough). One artifact 
could be manual scroll-back - it would perhaps be nice indeed to 
allow the scrollback to the top of the bootlog.

	Ingo
