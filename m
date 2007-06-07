Return-Path: <linux-kernel-owner+w=401wt.eu-S935770AbXFGTRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935770AbXFGTRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762152AbXFGTRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:17:08 -0400
Received: from styx.suse.cz ([82.119.242.94]:47446 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762360AbXFGTRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:17:07 -0400
Date: Thu, 7 Jun 2007 21:16:48 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: problem with softraw and keycodes > 128
Message-ID: <20070607191648.GC18372@suse.cz>
References: <4667C00D.40708@hhs.nl> <20070607131503.GA26905@suse.cz> <46681C5B.80201@hhs.nl> <20070607153639.GB5775@suse.cz> <466848F6.9010707@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466848F6.9010707@hhs.nl>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 08:05:42PM +0200, Hans de Goede wrote:
 
> This is an atkbd only setting, right, so indeed it doesn't affect USB, 
> right?

Right, what I meant is that USB keyboards are affected by the very same
problem you describe (163 in kernel will be 153 in X), and it can't be
worked around by setting softraw to 0.

> What I'm wondering if is there is any harm to setting softraw to 0, atleast 
> until there is a better fix. With it set to 0, for ps/2 keyboards all the 
> user addtionally needs todo is select the correct model, for which there 
> are nice gui tools.

By doing that, you'll be following a dead end road - and noone will fix
the issue for non-PS/2 keyboards. 

> Add a usb-keyboard (which in reality is the linuxkeyboard) model to the 
> mix, for the user to select / to make default even, and things will work 
> for usb users to, right?

Yes, but once you create the linuxkeyboard description, you don't need
softraw=0.

> >>   Since the xkb discriptions for most of the easy access keyboards
> >>   have been written by Suse, I assume the tested them and it works
> >>   for them. Does anyone know how suse does this?
> >
> >I don't think it does work. One of our guys is trying to fix it by
> >
> >	1) Converting the xkb multimedia keyboard descriptions to 
> >	setkeycodes descriptions
> >	2) Creating a "linux keyboard" X xkb description
> >
> >Then, after loading the setkeycodes at boot for the right keyboard
> >ty[e, AT keyboard will work fine, and USB and other keyboards will not
> >need *any* setup to have their multimedia keys working out of the box.
> 
> Thats good news, but what about gui tools to select the model, as this 
> cannot be autoprobed?

I'm sure SUSE will update some of the existing tools to work with the
kernel-based keyboard selection well.

> And what about portability of said tools to for example freebsd?

That will likely not work, obviously.

> Using xkb models should work across different OS's, and is available
> now.  All that is needed (for ps2 keyboards) is for the path of the
> special keys from the kernel to X-server to not change the codes.

Yes, the linux kernel solution is linux specific. But a lot of other
interfaces that X uses are OS specific.

-- 
Vojtech Pavlik
Director SuSE Labs
