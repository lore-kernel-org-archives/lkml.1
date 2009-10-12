Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbZJLPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbZJLPtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbZJLPte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:49:34 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:32976 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbZJLPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=F741WqqUEll6J68bZRSTMQSJH7/aEPfBGYs1ECD3HonOrL1MzqR7V+fF0hyxh3cbrq
         NBFhyk2aQJ9M9h4FNgVeVhcO+NznrdLbl0LrNURQeW468BcBY5nGGWrNFOqv3euSrUGP
         9uL7UOEGNebzMVTqEwVSUtr/m4J1anzkHsS3k=
Date: Mon, 12 Oct 2009 08:48:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
	anymore
Message-ID: <20091012154846.GB7996@core.coreip.homeip.net>
References: <4AD120F2.3020606@tremplin-utc.net> <20091011030029.GA6526@suse.de> <200910112135.29384.dmitry.torokhov@gmail.com> <4AD31709.4000103@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AD31709.4000103@tremplin-utc.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 01:46:17PM +0200, Éric Piel wrote:
> Op 12-10-09 06:35, Dmitry Torokhov schreef:
> > On Saturday 10 October 2009 08:00:29 pm Greg KH wrote:
> >> On Sun, Oct 11, 2009 at 02:04:02AM +0200, ?ric Piel wrote:
> >>> Hello,
> >>>
> >>> After a suspend, I used to do this (to get the PS2 keyboard working
> >>> again), and it used to work fine:
> >>> echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind ; sleep 1 ; echo
> >>> -n "i8042" > /sys/bus/platform/drivers/i8042/bind
> >>>
> >>> Unfortunately since 2.6.32-rc1, the unbind works fine, but the bind
> >>> returns a "no such device" error now (and the binding is not done). After
> >>> that, additional unbinds also report the error. I think 2.6.31 worked
> >>> fine. Any idea what's going wrong?
> >> Odd.  Any chance you can run 'git bisect' to figure out which patch
> >> might have caused it?
> > 
> > I8042 has been converted to use platform_driver_probe() - we are creating 
> > platform device and platform driver together, there is no chance that some 
> > other device might be driven by i8042 driver.
> I haven't finished bisecting, but indeed, the problem seemed to converge
> toward this patch.
> 
> 
> > Eric, do you still need to fiddle with i8042 to get your keyboard working with 
> > 2.6.32-rc3? We need to make sure that resube works without users needing to 
> > mess with bind/unbind.
> Yes, the keyboard doesn't work after the first resume from ram (the
> later resumes do work). I haven't tried any special option to the i8042
> driver. This is on a HP 2510, in 64 bits.

Could you please try and let me know if unloading at suspend and
reloading after resume atkbd and/or psmouse drivers and leaving i8042
alone "fixes" the issue?

> 
> Indeed, it would be great to fix this root problem! Is there any bug
> report opened to work on this?
> 
> However, currently the first problem is that unbind works, while bind
> doesn't. Which means anyone doing an unbind will have keyboard and mouse
> lost until the next reboot. That's rather bad because it has been
> recommended for a long time to have this kind of script at resume:
> http://intertrusion.com/files/hp-s2ram.patch
> http://en.opensuse.org/Pm-utils

*ahem* putting it sonewgere on the web does not really make it
"recommended" ;)

> 
> So at least, unbind should fail as well as bind.
>

That would be Greg's domain s it is driver core decision whether to
allow unbinding platform devices registered with
platform_driver_probe().

-- 
Dmitry
