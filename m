Return-Path: <linux-kernel-owner+w=401wt.eu-S937438AbYEUUix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937438AbYEUUix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937420AbYEUUiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:38:15 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:18486 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937362AbYEUUiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PiltiytzxOvsDA+du8+mpGsUQ/8LrbndSivENH98ndCgqV8xumEd78vyn9ummJib6K88t+fKA8Y8Ts2bu1CNM4aEi7Bv1Xq43pSDq4T66heM/ZvjIgSEE2pdLNuaGx4+kiWWYnDXPE3mCIeQwZsFrBTDRxGmmq1QF5M/B+/OdYg=
Date: Wed, 21 May 2008 16:38:08 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno Pr??mont <bonbons@linux-vserver.org>
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Message-ID: <20080521163638.ZZRA012@mailhub.coreip.homeip.net>
References: <200805162225.44284.bonbons@linux-vserver.org> <20080516163318.ZZRA012@mailhub.coreip.homeip.net> <200805162300.06027.bonbons@linux-vserver.org> <20080519114827.ZZRA012@mailhub.coreip.homeip.net> <20080519184501.38647a94@neptune.home> <20080521135345.ZZRA012@mailhub.coreip.homeip.net> <20080521220833.2e4345cb@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521220833.2e4345cb@neptune.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 10:08:33PM +0200, Bruno Pr??mont wrote:
> Hi Dmitry,
> 
> On Wed, 21 May 2008 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > Hi Bruno,
> > 
> > On Mon, May 19, 2008 at 06:45:01PM +0200, Bruno Pr??mont wrote:
> > > Hi Dmitry,
> > > 
> > > Please find attached dmesg output.
> > > 
> > > The suspend process looked somewhat like the following:
> > > - quick test of 
> > >     echo 1 > /sys/modules/i8042/parameters/debug
> > >   and disabled it again
> > >     echo 0 > /sys/modules/i8042/parameters/debug
> > > - exit X and rmmod usb-storage and a few other modules
> > >   (nfs, xfs and the like).
> > > - checked the extra keys (showkey) and enabled debug again
> > > - echo mem > /sys/power/state
> > > 
> > > Wait half a minute with laptop in S3
> > > 
> > > - hit enter to resume
> > > - wait a bit, as it takes too long help out with short
> > >   presses on power button (somehow it helps the HDD/CDROM
> > >   to resume), also pressed caps-lock when graphics were
> > >   resumed and cursor blinking (very slowly)
> > > - once userspace was awake again check extra keys with
> > >   showkeys
> > > - disabled input debug
> > > 
> > > I hope this is detailed enough.
> > > 
> > > List of patches applied to linux-2.6.25.4:
> > >   http://lkml.org/lkml/2008/5/16/430
> > >   http://lkml.org/lkml/2008/5/16/429
> > >   squashfs
> > > 
> > 
> > Question - does the problem happen if you dont have dritek extension
> > enabled (i.e. on unpatched kernel)?
> 
> When running 2.6.25.4 without the two dritek patches it does not
> redetect the keyboard (but obviously the extra keys don't work at all)
> 

Ah, ok, great.. I think we simply need to move dritek out of the place
where you put it in so it does not interfere with our efforts to
resume keyboard and mouse ;) I will see what I can do there..

-- 
Dmitry
