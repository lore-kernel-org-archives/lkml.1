Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYFTKSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYFTKSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYFTKR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:17:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYFTKR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:17:57 -0400
Date: Fri, 20 Jun 2008 12:17:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Bisecting tip/auto-x86-next?
Message-ID: <20080620101722.GD17692@elte.hu>
References: <485AFC9B.7090502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485AFC9B.7090502@gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> Hi,
>
> I am trying to track down a problem I reported here:
>
> http://lkml.org/lkml/2008/6/11/431

  [ GART related bootup crash. ]

> None or you were cc'd on the original report because I had no idea of 
> the source of the issue.  However, I have now narrowed down the 
> problem to the auto-x86-next tree.  Thus I did something like:
>
> $ git bisect start
> $ git bisect good linus/master
> $ git bisect bad tip/auto-x86-next

ok, in that case you can use tip's topical structure and probably bisect 
purely x86/gart, which has all x86 gart changes.

I.e. do something like this:

  git-checkout tip/x86/gart

build and boot that kernel, if it fails and mainline works then do:

  git-bisect reset
  git-bisect start
  git-bisect good linus/master
  git-bisect bad tip/x86/gart

this should drastically reduce the number of bisection steps needed, to 
3 or 4 iterations.

	Ingo
