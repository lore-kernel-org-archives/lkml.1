Return-Path: <linux-kernel-owner+w=401wt.eu-S1763235AbXGJSRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763235AbXGJSRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbXGJSQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:16:55 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:36956 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757301AbXGJSQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:16:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LN3ZTxG3ytntyxuIdYQKvoJr9dNeQE2Jlaqp9+X4M82F7CLt5YDQB5lSQHXoyeDFzhu2H0kBqeOWd0Bg2U/YSrRe+d6MDLQgDYiuLUkzydSVLSg3r9QLwO5C4AyfQ5Fj+K2kU0ow5G4bVCKS1bmdplOL5u0QpoDdT8N5bPzTXGA=  ;
X-YMail-OSG: RG8QTYEVM1kPXZlgSGzRHoD1Qy3.n8agyh5JEuzC6_IA7UAuZbmFz3w8NvnlAyIAz_2XMbojPw--
From: David Brownell <david-b@pacbell.net>
To: Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [linux-usb-devel] [PATCH] PXA27x UDC driver.
Date: Tue, 10 Jul 2007 11:16:48 -0700
User-Agent: KMail/1.9.6
Cc: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>,
       linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <20070628103619.GW13886@enneenne.com> <200706300646.14399.david-b@pacbell.net> <20070709135109.GO11451@enneenne.com>
In-Reply-To: <20070709135109.GO11451@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101116.48900.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007, Rodolfo Giometti wrote:
> On Sat, Jun 30, 2007 at 06:46:14AM -0700, David Brownell wrote:
> > 
> > Has someone actually signed up to develop and maintain such a
> > controller driver?  If so, that would be a Fine Thing, but not
> > one I've heard rumored before.  I've assumed that the best we'd
> > have is someone (Rodolfo?!) finally cleaning up a pxa27x version
> > so it could be merged.
> 
> That's what I wish to do... I wish cleaning up as much possible my
> pxa27x version af the driver so we can have something common where we
> can work on.

Good!


> Sorry for the delay but in these next days I'll read back all your
> suggestions and I'll provide a new patch ASAP.
> 
> However I would like avoiding to remove what I did on
> usb_ep_autoconfig() since I got functional g_ether device with RNDIS
> support... there could be another way to resolve this problem?

I *really* don't want to change the whole gadget stack just to
make one excessively quirky bit of hardware work with it ... when
we know there's a simple solution that doesn't involve that.

(Changing the whole gadget stack would involve retesting a boatload
of systems... not all of which are easily tested.  Plus, those changes
would need far more review than they can get just now.)

So for now, just do what I outlined before:  set up the pxa27x UDC
to resemble the pxa2[156] chips:  a bunch of bulk endpoint with no
altsettings and acting the same in all three hardware-supported configs.
That will support RNDIS.  In fact the only thing it _won't_ handle is
the "real CDC Ethernet" mode.

Once that's working, we can revisit the issue of how to configure
endpoint hardware ... focussing on just that issue, and with enough
flexibility that non-pxa27x hardware can also be addressed.

- Dave

