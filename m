Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbYE1BmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbYE1BmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759218AbYE1Blx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:41:53 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:20418 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758507AbYE1Blq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:41:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XCTncByeruEpa7HiuT+AJgSl5TlRIGtW9XT8lnhI9QljnYkZ1lOY5TU9jxfC+qImhje/Jv1VDbzLskeqktCTEhWx8wpuJhD+rUBcWivCEQTzl4/uhq7VoTeMOOuj/IJUpB5VQV4k0DdEOlYuKIc4aHBrMUy2aZP63sFiS4AbMvo=  ;
X-YMail-OSG: KV3QiiQVM1nuwq2gNeOY7hVVbgWvX6Pz9kIXxXD50JqE23MbTDr3ykTNACDi.4zXdZd5jqZZy4rbjFwLtLj13dygt9Peqqj4ZPfgRlCqjebmeZEoO_J3krMcrVG20knPxaw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
Subject: Re: HAVE_CLK (for <linux/clk.h> support)
Date: Tue, 27 May 2008 18:41:16 -0700
User-Agent: KMail/1.9.9
Cc: "Felipe Balbi" <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200805231044.59969.david-b@pacbell.net> <200805271614.55233.david-b@pacbell.net> <31e679430805271701h73ee1eb2p80329900008827f8@mail.gmail.com>
In-Reply-To: <31e679430805271701h73ee1eb2p80329900008827f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271841.16793.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008, Felipe Balbi wrote:
> >
> > I don't know of any other drivers with this particular issue,
> > but nonetheless ... I think the following is an appropriate
> > resolution.
> >
> > Comments from anyone else?
> 
> I actually like it. I didn't see this error cuz I was only building
> musb for arm architecture.
> 
> But why only davinci and omap?

They're the only one affected by the musb_hdrc patch...


> What about: mach-aaec2000, mach-at91, mach-ep93xx, mach-integrator,
> mach-lh7a40x, mach-ns9xxx, mach-pnx4008, mach-pxa, mach-realview,
> mach-sa1100, mach-versatile, mach-s3c24x.

If this approach goes forward, I'd expect those platforms
to "select HAVE_CLK" too.  Ditto some SH, PowerPC, etc.


> Instead of making the driver dependant on HAVE_CLK (which would be
> true for virtually any driver comming from linux-omap), you could make
> clk_enable a nop in case arch doesn't HAVE_CLK. How does that sound?

Best done by #ifdef HAVE_CLK in <linux/clk.h> support, and
putting the stubs there.  However, since those platforms
don't actually have clocks, I'd make them all report errors
of whichever kind.

That's kind of a second-order question to "should we create
a HAVE_CLK in Kconfig".  Since Certain People have objected
to patches touching <linux/clk.h> I avoided doing that the
first time around ... it'd be a better solution, yes.

- Dave

