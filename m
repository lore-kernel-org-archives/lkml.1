Return-Path: <linux-kernel-owner+w=401wt.eu-S1763874AbYETJXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763874AbYETJXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761121AbYETJXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:23:32 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:40246 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760934AbYETJXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:23:31 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-15.tower-51.messagelabs.com!1211275410!1051411!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Tue, 20 May 2008 11:23:12 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] UIO: generic platform driver
Message-ID: <20080520092312.GA10745@digi.com>
References: <20080422094708.GB27126@digi.com> <1208857977-29493-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1208857977-29493-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1208857977-29493-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080423085629.GA16776@digi.com> <20080427171201.GA3181@local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080427171201.GA3181@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 May 2008 09:23:12.0633 (UTC) FILETIME=[20465690:01C8BA5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

Hans J. Koch wrote:
> On Wed, Apr 23, 2008 at 10:56:29AM +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > Uwe Kleine-König wrote:
> > > Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> > > ---
> > > Hello,
> > > 
> > > This is the former patch 4/4 after some discussion.
> > > 
> > > Open issues:
> > >   - clock name "uio" isn't considered good by Russell King
> > >     I don't have a better suggestion
> > I added another branch[1] on my repo that doesn't have the dummy clk
> > patch and variant of this one that doesn't use the clk API.
> > 
> > This way the clk API isn't needed anymore for my patch and the issue
> > about the clock name disappeard, too.
> 
> Hi Uwe,
> sorry for the delay, I was away for a few days and had an awful lot of
> work when I came back.
> 
> About your generic platform driver: I think we've got two choices, both
> of them are acceptable as far as I'm concerned:
> 
> 1.) Use the clk API and make your driver depend on it. AFAICS, only ARM
> and PPC implement it right now. On some platforms, it will probably
> never be implemented. E.g. x86 doesn't have any clocks that could be
> controlled that way. It's probably only useful for SoCs.
> Advantages: People who need it get clk support for free, without having
> to write much code.
> Disadvantages: The generic platform driver is not available for all
> platforms. It might not be easy to implement the dependency in Kconfig
> in a way acceptable to all maintainers ;-)
> 
> 2.) Don't use the clk API. I don't think we would lose much. Drivers
> could implement clk stuff in their board support. You could add some
> generic function pointers in struct uio_platdata that are called in
> open/release/probe/remove. That way, any platform specific stuff,
> including clk, could be handled.
> Advantages: The generic platform driver is available for all
> platforms, no need for dependencies in Kconfig.
> Disadvantages: People who need clk_* must write a lot of code within
> their board support file. Not nice and clean...
> 
> I'm ready to accept 1.) or 2.), or even both of them (why can't we have
> two generic platform drivers?)
For now I suggest 2).  Using the clk API might be implemented by a
generic open/release routine.  Maybe I will look into that at a later
time.  For now I'm happy without clk support, too.

For now you can find two patches in my uio branch at
git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git uio

I rebased them to current Linus' master; otherwise they are unmodified
since the last posts.  For completeness I'll resend them as a reply to
this mail.

For shortlog and diffstat see below.

Best regards
Uwe

Uwe Kleine-König (2):
      UIO: don't let UIO_CIF and UIO_SMX depend twice on UIO
      UIO: generic platform driver

 drivers/uio/Kconfig    |   10 +++-
 drivers/uio/Makefile   |    1 +
 drivers/uio/uio_pdrv.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+), 2 deletions(-)

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
