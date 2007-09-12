Return-Path: <linux-kernel-owner+w=401wt.eu-S967062AbXILLLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967062AbXILLLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761410AbXILLK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:10:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46561 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbXILLKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:10:55 -0400
X-Auth-Info: GmBE4z+8KerBOtUmcsmHw7c90IlOFgb/GL1Vb4Wroro=
X-Auth-Info: GmBE4z+8KerBOtUmcsmHw7c90IlOFgb/GL1Vb4Wroro=
X-Auth-Info: GmBE4z+8KerBOtUmcsmHw7c90IlOFgb/GL1Vb4Wroro=
X-Auth-Info: GmBE4z+8KerBOtUmcsmHw7c90IlOFgb/GL1Vb4Wroro=
X-Auth-Info: GmBE4z+8KerBOtUmcsmHw7c90IlOFgb/GL1Vb4Wroro=
X-Auth-Info: GmBE4z+8KerBOtUmcsmHw7c90IlOFgb/GL1Vb4Wroro=
Subject: Re: SYSFS: need a noncaching read
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
To: Greg KH <greg@kroah.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Detlev Zundel <dzu@denx.de>
In-Reply-To: <20070912100123.GA23182@kroah.com>
References: <1189503798.6674.46.camel@Zeus.EmbLux>
	 <20070912053207.GH23573@pengutronix.de>  <20070912100123.GA23182@kroah.com>
Content-Type: text/plain
Organization: DENX
Date: Wed, 12 Sep 2007 13:13:32 +0200
Message-Id: <1189595612.6659.23.camel@Zeus.EmbLux>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg

Am Mittwoch, den 12.09.2007, 03:01 -0700 schrieb Greg KH:
> On Wed, Sep 12, 2007 at 07:32:07AM +0200, Robert Schwebel wrote:
> > On Tue, Sep 11, 2007 at 11:43:17AM +0200, Heiko Schocher wrote:
> > > I have developed a device driver and use the sysFS to export some
> > > registers to userspace.
> > 
> > Uuuh, uggly. Don't do that. Device drivers are there to abstract things,
> > not to play around with registers from userspace.
> > 
> > > I opened the sysFS File for one register and did some reads from this
> > > File, but I alwas becoming the same value from the register, whats not
> > > OK, because they are changing. So I found out that the sysFS caches
> > > the reads ... :-(
> > 
> > Yes, it does. What you can do is close()ing the file handle between
> > accesses, which makes it work but is slow.
> 
> Do an lseek back to 0 and then re-read, you will get called in your
> driver again.

No thats not true. I thought this too, but if I make a:

seek (fd, 0L, SEEK_SET);

in Userspace, there is no retrigger in the sysFS, my driver is *not*
called again. So I made a own sysfs_seek function, which does retrigger
the driver ...

Is this really wanted in the sysFS, that there is no way to retrigger a
read?

thanks
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

