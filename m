Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYJBJC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYJBJC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYJBJCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:02:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43786 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbYJBJCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:02:51 -0400
Date: Thu, 2 Oct 2008 11:02:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/8250.c: 'i' may be used uninitialized
Message-ID: <20081002090246.GD3550@elte.hu>
References: <f488382f0810010136t6280c10dg80458e3e9f02f598@mail.gmail.com> <1222850827-30522-1-git-send-email-steven@uplinklabs.net> <20081001223645.23ad0e5e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001223645.23ad0e5e@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Wed,  1 Oct 2008 01:47:07 -0700
> Steven Noonan <steven@uplinklabs.net> wrote:
> 
> > serial_unlink_irq_chain() does not initialize iterator 'i', and that is
> > correct logically because it is always initialized, either in the
> > hlist_for_each or in the conditional immediately after (which fires if
> > hlist_for_each comes up empty-handed). GCC does not realize this
> > connection and emits a false warning. Annotate it with uninitialized_var().
> > 
> > Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> 
> Ok definitive NAK. gcc 4.3.0 can work this out and doesn't produce a 
> warning. Thanks for sending the patch though (and to the gcc folks for 
> rendering it unnecessary)

thanks for sorting it out! A CONFIG_CC_DISABLE_WARNING_ANNOTATIONS=y 
might be useful as well, which could be used periodically (by gcc folks) 
to check which warnings are hidden by annotations?

	Ingo
