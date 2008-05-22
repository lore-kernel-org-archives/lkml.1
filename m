Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYEVTfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYEVTfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYEVTfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:35:24 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52297 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752246AbYEVTfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:35:23 -0400
Date: Thu, 22 May 2008 21:34:32 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support for the card
 detect line
Message-ID: <20080522213432.4a50629b@mjolnir.drzeus.cx>
In-Reply-To: <20080522181713.GA26918@polina.dev.rtsoft.ru>
References: <20080516165057.GC24196@polina.dev.rtsoft.ru>
	<20080517133633.5aa26938@mjolnir.drzeus.cx>
	<20080521184713.GA30284@polina.dev.rtsoft.ru>
	<20080521212831.523f344b@mjolnir.drzeus.cx>
	<20080522181713.GA26918@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 22:17:13 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Wed, May 21, 2008 at 09:28:31PM +0200, Pierre Ossman wrote:
> > 
> > Fair enough. You should probably add a comment about this somewhere so
> > that people do not call get_cd() in the core request function and
> > similar places. Place it so that both get_cd() and get_ro() are covered
> > though, as it should be relevant for both.
> 
> I think this is applicable to the .set_ios() too.
> 

Indeed. That tends to be more obvious that it is costly though.

> > 
> > This can be solved by allowing get_cd() to return an error that will be
> > treated as if get_cd() wasn't defined. -ENODEV seems suitable.
> 
> -ENOSYS (not implemented) sounds better for this purpose...
> 

Even better. :)

> > (get_ro() needs the same treatment, but I haven't gotten around to
> > that)
> 
> Ok. How about this version?
> 

Perfect. Unless there is some way you can pass flags in platform data?
Using the lack of an init() to determine the need for polling is a bit
circumstantial.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
