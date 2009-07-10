Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZGJK0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZGJK0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZGJK0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:26:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43959 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbZGJK0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:26:31 -0400
Date: Fri, 10 Jul 2009 12:25:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kernel.printk.c - ensure that "console enabled"
	messages are printed on the console
Message-ID: <20090710102547.GD5499@elte.hu>
References: <200907040017.26921.rgetz@blackfin.uclinux.org> <200907091308.37370.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907091308.37370.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> From: Robin Getz <rgetz@blackfin.uclinux.org>
> 
> Today, when a console is registered without CON_PRINTBUFFER, end 
> users never see the announcement of it being added, and never know 
> if they missed something, if the console is really at the start or 
> not, and just leads to general confusion.
> 
> This re-orders existing code, to make sure the console is added, 
> before the "console [%s%d] enabled" is printed out - ensuring that 
> this message is _always_ seen.
> 
> This has the desired/intended side effect of making sure that 
> "console enabled:" messages are printed on the bootconsole, and 
> the real console. This does cause the same line is printed twice 
> if the bootconsole and real console are the same device, but if 
> they are on different devices, the message is printed to both 
> consoles.
> 
> Signed-off-by : Robin Getz <rgetz@blackfin.uclinux.org>
> 
> ---
> 
>  printk.c |   44 +++++++++++++++++++++++++++++---------------
>  1 file changed, 29 insertions(+), 15 deletions(-)
> 
> patch generated for -tip

Looks good, applied it to tip:core/printk for v2.6.32, thanks Robin. 

i fixed a couple of small details in the patch:

 - re-broke the commit log as it was too wide for nice git log 
   output

 - fixed a stray whitespace warned about by scripts/checkpatch.pl

 - fixed another stray whitespace found the old fashioned way

 - fixed the patch title to match the prefix used by your previous 
   commit as well

	Ingo
