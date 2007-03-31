Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbXCaDjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbXCaDjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbXCaDjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:39:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:34899 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853AbXCaDje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:39:34 -0400
Date: Fri, 30 Mar 2007 20:11:29 -0700
From: Greg KH <gregkh@suse.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [patch 32/37] CRYPTO: api: scatterwalk_copychunks() fails to
	advance through scatterlist
Message-ID: <20070331031129.GA1784@suse.de>
References: <20070330205938.984247529@mini.kroah.org> <20070330210651.GI29450@kroah.com> <460DBC4C.1060602@trash.net> <20070331021437.GA31298@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331021437.GA31298@gondor.apana.org.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 12:14:37PM +1000, Herbert Xu wrote:
> On Sat, Mar 31, 2007 at 03:41:32AM +0200, Patrick McHardy wrote:
> >
> > > [CRYPTO] api: scatterwalk_copychunks() fails to advance through scatterlist
> > 
> > This patch seems to cause some problems, I get reproducable freezes
> > on the receiving system with net-2.6.22 when sending IPsec packets
> > larger than the mtu (reproduced about 10 times). Reverting this
> > patch seems to fix it. In a few cases the oops also occured on the
> > sending system.
> > 
> > Backtrace from UML (sending system):
> > 
> > uml:~# ping 10.0.0.1 -s 20000
> > PING 10.0.0.1 (10.0.0.1) 20000(20028) bytes of data.
> > BUG: soft lockup detected on CPU#0!
> > Call Trace:
> 
> Indeed.  That patch was buggy.  Sorry for not catching this earlier.
> 
> This should fix the problem.
> 
> [CRYPTO] api: Use the right value when advancing scatterwalk_copychunks
> 
> In the scatterwalk_copychunks loop, We should be advancing by
> len_this_page and not nbytes.  The latter is the total length.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Is this an "add-on" patch, or a replacement one?

thanks,

greg k-h
