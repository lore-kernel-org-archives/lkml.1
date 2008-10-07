Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYJGJ0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYJGJ0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYJGJ0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:26:10 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:27851 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752953AbYJGJ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:26:08 -0400
Date: Tue, 7 Oct 2008 13:26:05 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Tejun Heo <tj@kernel.org>
Cc: Matt Sealey <matt@genesi-usa.com>, Jeff Garzik <jgarzik@pobox.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Li Yang <leoli@freescale.com>,
       Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
Message-ID: <20081007092605.GA28907@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru> <48EA77EF.6080502@genesi-usa.com> <20081006213209.GA13072@oksana.dev.rtsoft.ru> <48EABBD3.1010401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <48EABBD3.1010401@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 10:30:59AM +0900, Tejun Heo wrote:
> Anton Vorontsov wrote:
> > On Mon, Oct 06, 2008 at 03:41:19PM -0500, Matt Sealey wrote:
> >> There is a simple problem with the patch which is that an "IRQ 0" can and does
> >> actually exist on a bunch of platforms, at least to the best of my knowledge.
> >>
> >> Checking for -1 (which means for definite, no irq at all, because it is
> >> totally unambiguous, as a -1 IRQ numbering is "impossible") is more correct.
> > 
> > This was discussed years ago.
> > 
> > http://lkml.org/lkml/2005/11/22/159
> > http://lkml.org/lkml/2005/11/22/227
> > 
> 
> Would this break any existing platforms?

Nope.

The driver is only available for PPC platforms.

As time goes by one can change `depend on PPC_OF' to just `depends on
OF', so that the driver will be also available for SPARC. And still
it will work, because SPARC also understands VIRQ0 as invalid VIRQ.


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
