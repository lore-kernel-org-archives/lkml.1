Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZJSI3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZJSI3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZJSI3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:29:22 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:36811 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbZJSI3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:29:21 -0400
Subject: Re: nfs mount fail
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091019082333.GA27410@elte.hu>
References: <20091019114339.4b67d947@infradead.org>
	 <1255921080.839.2.camel@penberg-laptop>
	 <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com>
	 <1255933848.11116.2.camel@heimdal.trondhjem.org>
	 <20091019065433.GA29550@elte.hu> <1255935518.18914.0.camel@penberg-laptop>
	 <20091019070825.GA16493@elte.hu>
	 <86802c440910190031m33e116d3o90869de5212bb2e@mail.gmail.com>
	 <1255938774.11116.35.camel@heimdal.trondhjem.org>
	 <20091019080403.GA24036@elte.hu>  <20091019082333.GA27410@elte.hu>
Content-Type: text/plain
Date: Mon, 19 Oct 2009 17:29:11 +0900
Message-Id: <1255940951.14447.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 2 sum rcpts/h 15 sum msgs/h 3 total rcpts 1701 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: B29FB575D34A1A3945B93F7C125490F536C8AAB0
X-UiO-SPAM-Test: remote_host: 220.106.13.183 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 4 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 10:23 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > > --- a/fs/nfs/super.c
> > > > +++ b/fs/nfs/super.c
> > > > @@ -1253,6 +1253,7 @@ static int nfs_parse_mount_options(char *raw,
> > > >  			default:
> > > >  				dfprintk(MOUNT, "NFS:   unrecognized "
> > > >  						"transport protocol\n");
> > > > +				kfree(string);
> > > >  				return 0;
> > > >  			}
> > > >  			break;
> > > 
> > > There is a possible clean up there too. We can move the other kfree() 
> > > calls out of the inner switch statement, and coalesce them all into a 
> > > single call.
> > 
> > Correct - separately from the leak fix. (which potentially wants to go 
> > to -stable as well)
> 
> Not necessarily -stable material though - this is a really light memory 
> leak and only on a rare failure path, i doubt anyone noticed in 
> practice.
> 
> So d508afb fixed all that needed fixing and there's nothing serious 
> pending here. I've reverted all pending bits in tip:out-of-tree, so it's 
> pure -git now. I rarely have to carry any NFS fixes in out-of-tree, this 
> was an odd-one-out exception that fell through the cracks.
> 
> 	Ingo

OK. Could you resend the remaining leak fix, with the fixed up changelog
and attributions so I can pass it on to Linus?

Trond

