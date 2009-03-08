Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZCHOgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZCHOgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 10:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZCHOgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 10:36:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55672 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZCHOgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 10:36:43 -0400
Date: Sun, 8 Mar 2009 14:36:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Hughes <hughsient@gmail.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hal@lists.freedesktop.org
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Message-ID: <20090308143636.GA26233@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org> <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru> <20090307150640.GA3516@srcf.ucam.org> <200903071839.16508.arvidjaar@mail.ru> <20090307154424.GA3909@srcf.ucam.org> <15e53e180903071219q4ed318edt2fa8f492426c0ab6@mail.gmail.com> <20090307202647.GA9776@srcf.ucam.org> <15e53e180903080033h5e990f08o3622afae018c38ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15e53e180903080033h5e990f08o3622afae018c38ca@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 08:33:48AM +0000, Richard Hughes wrote:
> On Sat, Mar 7, 2009 at 8:26 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Mapping KEY_SUSPEND to hibernate is what we've been doing for years.
> > It's what hal *still does*.
> 
> Sure, but how much userspace now listens to HAL for these events? Xorg
> and evdev has taken over that role for all the session. We can ship a
> trivial patch as an fdi file to HAL to remap this if required.

I've no idea. But I lean towards not gratuitously breaking it for no 
reason other than aesthetics.

> > KEY_SLEEP has been the suspend to RAM key forever.
> 
> Except if you're a USB keyboard. Grep through the kernel sources and
> see how many drivers get this wrong. We can't map three sleep states
> to two buttons in any sane way. For instance, is the sleep acpi button
> supposed to trigger a suspend of hibernate? Surely this is user policy
> as it is not specified on the the exterior of the machine.

We do it the same way we've previously done it (and the same way it 
works outside the Linux world) - the "suspend to RAM" key has 
configurable behaviour. As far as I can tell, the USB driver does the 
right thing here?

> > How are we supposed to perform this transition? We've no idea
> > how much of userspace makes the same assumption.
> 
> FWIW, I think emitting KEY_ events (not switch events) in HAL is crazy
> as now we can just use the fixed Xorg in the session. FWIW, HAL gets
> other keys wrong too, for instance KEY_BATTERY is mapped to
> display_off, but nobody has noticed as we've been using Xorg since
> ages.

I'm happy with obvious bugs being fixed, but this isn't an obvious bug - 
it's purely an aesthetic issue. We don't need to draw a distinction 
between generic sleep and suspend to RAM keys, especially if the cost of 
doing so is having to fix up an undefined quantity of userspace.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
