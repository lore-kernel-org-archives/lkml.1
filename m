Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYFRUJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYFRUJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYFRUI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:08:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYFRUIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:08:55 -0400
Date: Wed, 18 Jun 2008 22:08:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: David Miller <davem@davemloft.net>, vgusev@openvz.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, mcmanus@ducksong.com,
       ilpo.jarvinen@helsinki.fi, kuznet@ms2.inr.ac.ru, xemul@openvz.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [E1000-devel] [TCP]: TCP_DEFER_ACCEPT causes leak sockets
Message-ID: <20080618200805.GA18756@elte.hu>
References: <20080617083220.GA11393@elte.hu> <20080617.020840.169830916.davem@davemloft.net> <20080617092706.GB20621@elte.hu> <20080617.022909.173003136.davem@davemloft.net> <20080617093929.GA10334@elte.hu> <48595910.8000905@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48595910.8000905@intel.com>
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


* Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> > Any ideas about what i should try next?
> 
> have you tried e1000e?

will try it.

But even it if solves the problem it's a nasty complication: given how 
many times i have to bisect back into the times when there was only 
e1000 around, how do i handle the transition? I have automated bisection 
tools, etc. and i bisect very frequently.

It's a real practical problem for me: if i have E1000E=y in my .config 
and go back to an older kernel, i lose that .config setting in 'make 
oldconfig'. Then when the bisection run happens to go back into the 
E1000E times, 'make oldconfig' picks up E1000E with a default-off 
setting - and things break or work differently.

no other Linux driver i'm using forces me to do that and i rely on many 
of them and i rely on proper 'make oldconfig' behavior on a daily basis. 
Until now i was able to do automatic bisection back for _years_, to the 
v2.6.19 times. You broke that.

And that's just one driver out of thousands of Linux drivers. Imagine 
what happened to bisectability and migration quality if every driver 
version update was this careless about its installed base as 
e1000/e1000e.

The e1000 -> e1000e migration it was not only done in an incompetent, 
amateurish way, you also ignored real feedback and that combined 
together is totally lame and inacceptable behavior in my book. You 
should not expect praise and roses from me as long as you do stupid 
things like that.

	Ingo
