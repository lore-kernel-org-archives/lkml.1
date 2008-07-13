Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYGMVyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYGMVyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYGMVyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:54:05 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:45014 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754121AbYGMVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:54:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UVM3yYtNvRIiMJrLiRsIrYRvzIvZC9xTzfSGAL1cEXFH2RdmncllrGghilHMrjB3wv65nQN+XoLu4v2DIu5DpQHJ6MzkXqiVmNG5scDPEJRrkWpALt8JnXmZgV5jYak01PHsUxWvZ04sKInj+olg2gVw7AnI/ajDC1zlpIGQoXw=  ;
X-YMail-OSG: ReK3J3YVM1na0l7lOe8P4ycc7.IGe8AfCw_6v.WyajBfZj9ZxNs5a87GEE4.Pv4Zb9FI8RXKF8ipL4l7gizv4rVWHqfi2JWDpfEyMaSWyb0ecR67aQUIKH1stKJ23nJPR98-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] genclk: add generic framework for managing clocks.
Date: Sun, 13 Jul 2008 14:54:01 -0700
User-Agent: KMail/1.9.9
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
References: <20080708134242.GA6176@doriath.ww600.siemens.net> <200807131412.32961.david-b@pacbell.net> <20080713142317.97111c81.akpm@linux-foundation.org>
In-Reply-To: <20080713142317.97111c81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807131454.01389.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 July 2008, Andrew Morton wrote:
> On Sun, 13 Jul 2008 14:12:32 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > On Saturday 12 July 2008, Andrew Morton wrote:
> > > > +EXPORT_SYMBOL(clk_get_parent);
> > > 
> > > As this is a new kernel-wide utility library, it is appropriate that
> > > all of its public interfaces (at least) be documented. __An appropriate
> > > way of doing that is via kerneldoc annotation. __Please don't forget to
> > > document return values and call environment prerequisites (eg: requires
> > > foo_lock, may be called from interrupt context, etc, etc).
> > 
> > That is, the stuff that's not already documented in <linux/clk.h>;
> > that's where clk_get_parent() is documented, for example.
> 
> argh.  That's why I missed it - please don't document stuff in header
> files.  The usual approach is to document interfaces at the
> implementation site.

When it's a pure interface, I don't see a better option than having the
kerneldoc live in the header file ...

What Dmitry has provided is one implementation framework.  It's not
clear it's general enough to become "the" implementation framework, or
that it should be.  ISTR that it's not ready to handle OMAP clocks
yet ... those would be the acid test for any proposal that there be
a standard implementation framework.

 
> Except for structs where of course there is no choice.  But then,
> the .h file _is_ the definition site.

That matches <linux/clk.h> to a tee:  the header *is* the definition
of the interface.

- dave

 


