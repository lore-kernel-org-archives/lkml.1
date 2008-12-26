Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYLZTsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYLZTsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYLZTsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:48:13 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:37508 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751663AbYLZTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:48:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=W2iyQNaj/6w7uhx2IZA+pdf416D13ZJ3/ltE/qv0xwG09OybnVKBtEvA8aY3mSw25mkxQFi5TbDY+QAyb2Ud6fPubic0c1/pY5CnSbezBQo7jRNYBnpirIzJn4Z0dedJPjQAVkeCM22qFtnb4GfGwYbI9cY+qED2FkaenU6fyko=  ;
X-YMail-OSG: xsc_rggVM1ntR2H9e3sQghjYwwEdYYYQQp.lDsZjv41QiYZWiOMqnJJ_1DsIezPJCvwP1hD.O0_vCSNA7FBXa3T86G3v2aVMM5ZYv5eHIr8OynvHkVoKSE9o9yrik6xTHOYyWE2fUlxXKaEm8wrIdnjcyB0LCkBZSpVo.LpLLUwINZ0kU.kVaz4Y79fD4Q9_tiwgRDxISfc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Philip Langdale <philipl@overt.org>
Subject: Re: MMC: Add 8-bit bus width support
Date: Fri, 26 Dec 2008 11:48:09 -0800
User-Agent: KMail/1.9.10
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       lkml <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>
References: <200812260947.21672.david-b@pacbell.net> <49552CF5.60705@overt.org>
In-Reply-To: <49552CF5.60705@overt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812261148.09668.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 December 2008, Philip Langdale wrote:
> David Brownell wrote:
> >> I am not aware of mmc cards having 8 pins yet.
> > 
> > Transcend seems to have one that's reasonably available;
> > NewEgg has the 4GB card for $US 9.50, and Transcend sells
> > it direct too (at least in the US).  I'm a bit curious
> > what read rates they achieve ... likely not 50 MB/sec!
> > 
> > The relevant search keyword seems to be "MMCplus".
> 
> Right. MMCplus and MMCmobile cards are all required to have
> 8 bit support, and they've been around for years. 

Specs have been around.  Products have been harder
to find, at least at retail, in part because of the
catch you mention:

> The catch 
> is that there have been essentially no controllers out in
> the wild which can take advantage of them. Even when the
> controller chip supports 8 bit operation, the ODM usually
> only connects 4 pins up

SD cards only need 4 pins, of course.  And until the
8-bit MMC cards get more common, there's not much
point in using those more expensive sockets. 


> - and when they actually do, it's 
> for a controller which we don't know how to control :-)
> 
> This OMAP controller is a first.

OMAP SOCs have a way of doing that for more than one
technology at a time, in my observation.  ;)

Right now OMAP3 boards with 8-bit MMC support are widely
available via beagleboard.org ... for $US 150, you get
quite a lot.  But end-user boards, vs developer ones,
still don't use those sockets a lot.


> > A third use for 8-bit bus widths is the CE-ATA.org stuff
> > (ATA over MMC) ... I'm not sure how real that is, but the
> > Seagate website has two "Lyrion" products of 30MB and 60MB
> > using 8-bit MMC for small disks.  I had thought bigger
> > drives had been announced (e.g. from Samsung, 200+ MB);
> > maybe they're visible only through OEM channels.
> 
> True - except that CE-ATA wants to signal ATA command completion
> on the CMD line which I'm fairly certain requires explicit
> hardware level support. In the absence of that, you'd have to
> poll.

ISTR seeing a slide showing four options for that.

Software polling is always possible ... but it's
usually easy to get an IRQ from a spare GPIO line,
the controller need not support that explicitly.

I've seen *one* Linux board with a CE-ATA connector,
and that was the 4-bit version.  Presumably when
Linux grows a CE-ATA driver, this issue will get
dealt with.

- Dave
  

> 
> --phil
> 
> 


