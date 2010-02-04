Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab0BDXi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:38:29 -0500
Received: from mail.vyatta.com ([76.74.103.46]:57924 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934Ab0BDXi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:38:28 -0500
Date: Thu, 4 Feb 2010 15:38:07 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Cc: "Dave Miller" <davem@davemloft.net>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.33 1/4] net: Micrel KSZ8841/2 PCI Ethernet driver
Message-ID: <20100204153807.69d9037a@nehalam>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A51@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A51@MORGANITE.micrel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 15:18:54 -0800
"Ha, Tristram" <Tristram.Ha@Micrel.Com> wrote:

> Dave Miller wrote:
> >> This is a resubmission of the Micrel KSZ8841/2 PCI Ethernet driver.
> >
> > The procfs stuff is a non-starter.
> >
> > There will undoubtedly be other devices that have switch-like
> > facilities that we'd like to export configuration support for.
> >
> > The last thing we want is a bunch of procfs files that each
> > driver decides the layout and behavior of.
> >
> > We need a centralized way to config such things, and probably
> > the best is to have a rtnl_link_ops facility to get at the
> > ports and configure them with attribute blobs or similar.
> >
> > We also said in your first submission that the way you're
> > getting at the bridge STP stuff with things like:
> >
> > +/* Needed for STP support. */
> > +#ifdef CONFIG_KSZ8842_STP
> > +#include <../net/bridge/br_private.h>
> > +#endif
> > Yet you left all of this stuff in there.
> 
> In my discussions with Alan Cox and Stephen Hemminger, I thought they kind of agree to the code's inclusion in the driver.  Sorry for my misunderstanding.  I will submit another one with those code removed.
> 
> P.S. I did not actually receive your response from my company's e-mail server.  I copied it from LKML.

I would rather move any defines needed by driver to
new file: include/net/bridge.h
and include it in br_private.h

Don't want device dumpster diving into bridge control structures.

-- 
