Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbXHQVad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbXHQVad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761045AbXHQV3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:29:38 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:30217 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760594AbXHQV3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:29:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VmFJoSngdAhNlIl+J1ZH3tUCX6f96O21f4MEhaTkSgQFLbZKwnOqjJu6fyzGhhMhzn8h+HyEO+sMmexevfeMGlpYLYWvL0gX+6nxol/rEoxKMGQnogg86a/tdzB1mZ9ZxeH0FOGZuAt4ayT1oWWa4k1ORCvNjhGmCWK0r3C77UA=  ;
X-YMail-OSG: UUrsy0gVM1kD1eCoHh.VuhiUrdXyLtOER6vsc9KaORgE8dhAYgqAOEtTcT_Lkkc8MaXMSjcYTNqq9iIMV2STsYmDCmK7JUcvxIFI7O6QhwBh9LwgHw26.bnaiXkhkJ92iWaiWs_XcuinKuE-
From: David Brownell <david-b@pacbell.net>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 01/12] Blackfin arch: add peripheral resource allocation support
Date: Fri, 17 Aug 2007 14:10:59 -0700
User-Agent: KMail/1.9.6
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <600D5CB4DFD93545BF61FF01473D11AC0D87BD9F@limkexm2.ad.analog.com>
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC0D87BD9F@limkexm2.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171411.00145.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Hennerich, Michael wrote:
> Hi Dave,
> 

> Right - our patch descriptions needs to be worked on.  

Yes, please ... that makes reviewing easier!
 

> For a well experienced 
> systems engineer being the same time the same guy who does the Hardware
> and the Software this is not an issue.

I guess I've rarely come across job descriptions like that.
Lowlevel software folk need to be able to use schematics and
often test equipment, but not design product circuits ... and
circuit designers rarely have responsibility to ship software.

On the other hand, maybe you want your "typical" customer to
be more of a systems integrator than anything else.


> We provide all kind of drivers utilizing almost any peripheral on
> Blackfin.

Chip vendors supporting Linux drivers for all their hardware.
What a pleasant change!  :)


> While potentially causing conflicting usage, for someone without
> detailed hardware knowledge. The platform device board file is a good
> thing to track conflicting memory or IO space resources as well as IRQs.
> We also utilize platform device files for exactly these purposes.
> 
> The dynamic resource allocation for pinmux and gpio seems to us the best
> way to handle things. The "resource allocation" mechanism will spill an
> error and dump in case conflicting usage is detected. It'll also tell
> you who is causing the conflicting usage.       

That's your call, of course.  I was pointing out why the "early"
binding of pin resources is the more usual strategy with Linux.
A "late" strategy is a bit surprising, and has its own issues.


> >That said, how you handle pinmux on Blackfin is your business.
> >
> >But you should know that this approach seems idiosyncratic and
> >more complex than needed:  when pin config is done early and as
> >part of board setup, drivers don't need to care about it or to
> >handle any pinmux errors.  And heck, products can sometimes be
> >shipped with the bootloader having done all pinmux setup, so
> >Linux won't need to worry about it at all.  That can help ship
> >multiple board revisions using the same kernel.
> 
> This works for fixed function boards.

That is, for typical products embedding Linux...


> But not for development boards 
> where we provide lego like add on cards, and allow people to connect
> their homebrewn hardware.  

Development boards are usually run differently than product
boards.  All that flexibility in the development boards is
not necessarily a feature in the product version; it costs
space and time, which the application may need.  Being able
to shift costs *early* and then drop them at runtime is a
useful strategy to apply in most places.

And heck -- most development setups get used only with one
card stack at a time, and it's easy to install new kernels
for new stacks.

- Dave
