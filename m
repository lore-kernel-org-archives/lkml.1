Return-Path: <linux-kernel-owner+w=401wt.eu-S1762040AbXJFLIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762040AbXJFLIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 07:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbXJFLIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 07:08:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54678 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbXJFLIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 07:08:46 -0400
Date: Sat, 6 Oct 2007 13:08:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
Message-ID: <20071006110835.GA24463@elte.hu>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Engelhardt <jengelh@computergmbh.de> wrote:

> Colored kernel message output
> 
> Let's work more on Linux's cuteness! 
> [http://lkml.org/lkml/2007/10/4/431] The following patch makes it 
> possible to give kernel messages a selectable color which helps to 
> distinguish it from other noise, such as boot messages. NetBSD has it, 
> OpenBSD has it, FreeBSD to some extent, so I think Linux should too.
> 
> Inspired by cko (http://freshmeat.net/p/cko/), but independently
> written, later contributed forth and back.
> 
> Already posted at: http://lkml.org/lkml/2007/4/1/162
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

looks really good to me!

Reviewed-by: Ingo Molnar <mingo@elte.hu>

small nit:

+       vc->vc_color = printk_color;
+       update_attr(vc);

that should be in a set_vc_color() function and the new code should do:

+	set_vc_color(vc, vc->vc_color);

(and same at the other places that call update_attr() as well)

feature request: would be interesting to have a color table (defined in 
the .config) dependent on message loglevel. That way KERN_CRIT messages 
could be red, KERN_INFO ones white, etc.

	Ingo
