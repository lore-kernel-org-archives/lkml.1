Return-Path: <linux-kernel-owner+w=401wt.eu-S1764218AbZFMVHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764218AbZFMVHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759659AbZFMVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:06:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763656AbZFMVGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:06:35 -0400
Date: Sat, 13 Jun 2009 22:31:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: -git tree build failure =?utf-8?B?IzI6?=
	=?utf-8?Q?_drivers=2Fnet=2Fcnic=2Ec=3A2520=3A_error=3A_implicit_declarati?=
	=?utf-8?B?b24gb2YgZnVuY3Rpb24g4oCYX19zeW1ib2xfZ2V04oCZ?=
Message-ID: <20090613203100.GA14294@elte.hu>
References: <20090612184343.GA11900@elte.hu> <4A32A1E4.8080708@oracle.com> <20090613062933.GA14034@elte.hu> <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > --- a/drivers/net/cnic.c
> > +++ b/drivers/net/cnic.c
> > @@ -25,6 +25,8 @@
> >  #include <linux/delay.h>
> >  #include <linux/ethtool.h>
> >  #include <linux/if_vlan.h>
> > +#include <linux/module.h>
> > +
> 
> That makes no sense. 
> 
> Look at the first #include in the file - it already includes 
> <linux/module.h>.
> 
> Why do we need to do it twice?

Hm, indeed ... weird - i pasted that error message from a direct 
reproducer and when i added module.h the build failure disappeared. 
James - please discard the second patch for now, there's something 
fishy here.

I tried to reproduce this second problem with the configs i 
saved/sent and failed. I'll now started tests with just Randy's fix.

	Ingo
