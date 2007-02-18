Return-Path: <linux-kernel-owner+w=401wt.eu-S2993035AbXBRBqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993035AbXBRBqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 20:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993038AbXBRBqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 20:46:37 -0500
Received: from web36708.mail.mud.yahoo.com ([209.191.85.42]:47094 "HELO
	web36708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2993035AbXBRBqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 20:46:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=znOvrA+owYhGJDhX3SLKqm/J/StDCP4+5uot22aSaNGdeNoXqW4Mi6aoxMdKJiSQDHmHdqe1hFgkBoWBromBfTbLsy22IDweIhyMG2Xb5K89PhJoBctnB3OM6/kVVR0ZhdY9FXe785RcQZZqHQPjOrDFP7iI/d1qPMSx35i9a+E=;
X-YMail-OSG: o8f144MVM1mTVaQ.crOiYkjbtmdLiiND3G68DbFkzQ0qeYPnT7iZ6whmUdeJjOy_J2lYe27hxBeBoIefe7w0OFw5_t32AugElbh1tMxollr_7xnliD4IBkeQLaOfyfxH4sDv2BlJ.nzpKOM-
Date: Sat, 17 Feb 2007 17:46:35 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] incorrect behavior on resume
To: Pavel Machek <pavel@ucw.cz>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070218002903.GF14773@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <40069.12630.qm@web36708.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pavel Machek <pavel@ucw.cz> wrote:

> On Sun 2007-02-18 00:35:33, Pierre Ossman wrote:
> > Alex Dubov wrote:
> > > And today: yet another problem with mmc.
> > > It so happens that after resume mmc layer issues requests to the device before
> mmc_resume_host is
> > > called at all. Moreover, this prevents the machine from resuming, unless worked around,
> because
> > > software timer does not work at this stage of the resume and interrupts may not be delivered
> (if
> > > card was removed, for example).
> > 
> > Now this sounds incredibly broken. A child device should never be resumed before
> > its parent. Pavel, can you comment?
> 
> No, child devices should not be resumed before their parents. Is it
> true child?
> 
> What bus is mmc on? Timer should be resumed fairly early...?
> 
> Can you confirm that rmmod/insmod of mmc around suspend fixes the issue?
> 
> But this is greg's area.
It sure does - if I'll do "rmmod mmc" I'd be forced to remove my driver as well (symbol
dependency) and the problem will magically disappear.

The problem here is that mmc_block's device is a child of real device (tifm_dev here), so it gets
resumed right after it. However, it correct functioning depends on mmc_core, which must be
manually resumed (mmc_resume_host). Therefore, I think this is purely mmc's problem.



 
____________________________________________________________________________________
Bored stiff? Loosen up... 
Download and play hundreds of games for free on Yahoo! Games.
http://games.yahoo.com/games/front
