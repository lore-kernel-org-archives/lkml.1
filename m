Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZJSIXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZJSIXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbZJSIXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:23:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbZJSIXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:23:39 -0400
Date: Mon, 19 Oct 2009 10:23:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nfs mount fail
Message-ID: <20091019082333.GA27410@elte.hu>
References: <20091019114339.4b67d947@infradead.org> <1255921080.839.2.camel@penberg-laptop> <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com> <1255933848.11116.2.camel@heimdal.trondhjem.org> <20091019065433.GA29550@elte.hu> <1255935518.18914.0.camel@penberg-laptop> <20091019070825.GA16493@elte.hu> <86802c440910190031m33e116d3o90869de5212bb2e@mail.gmail.com> <1255938774.11116.35.camel@heimdal.trondhjem.org> <20091019080403.GA24036@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019080403.GA24036@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > > --- a/fs/nfs/super.c
> > > +++ b/fs/nfs/super.c
> > > @@ -1253,6 +1253,7 @@ static int nfs_parse_mount_options(char *raw,
> > >  			default:
> > >  				dfprintk(MOUNT, "NFS:   unrecognized "
> > >  						"transport protocol\n");
> > > +				kfree(string);
> > >  				return 0;
> > >  			}
> > >  			break;
> > 
> > There is a possible clean up there too. We can move the other kfree() 
> > calls out of the inner switch statement, and coalesce them all into a 
> > single call.
> 
> Correct - separately from the leak fix. (which potentially wants to go 
> to -stable as well)

Not necessarily -stable material though - this is a really light memory 
leak and only on a rare failure path, i doubt anyone noticed in 
practice.

So d508afb fixed all that needed fixing and there's nothing serious 
pending here. I've reverted all pending bits in tip:out-of-tree, so it's 
pure -git now. I rarely have to carry any NFS fixes in out-of-tree, this 
was an odd-one-out exception that fell through the cracks.

	Ingo
