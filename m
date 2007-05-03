Return-Path: <linux-kernel-owner+w=401wt.eu-S1031286AbXECUci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031286AbXECUci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031206AbXECUch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:32:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:62999 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031300AbXECUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p88uy1j5T2JgcwmpCFAhKazNHe917SnLqpANFeI78iD6XnTODP7o/FlZjCTtDAOGR4rTtm6nGn9bUvaQTCvYFeyAzncYf6U36Mlu1ic1ggm63kzhS4juSukmPB8BQqvMWDo1ZTK7CeKGkrL+2ma00LWWlbFZ1EW98Q5Qvt49V08=
Message-ID: <d120d5000705031332o444415favd3f245ccdea95bea@mail.gmail.com>
Date: Thu, 3 May 2007 16:32:33 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
Cc: "Michael Schmitz" <schmitz@opal.biophys.uni-duesseldorf.de>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Michael Schmitz" <schmitz@debian.org>
In-Reply-To: <Pine.LNX.4.64.0705032124020.1479@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070501195052.390551603@mail.of.borg>
	 <20070501195129.842338339@mail.of.borg>
	 <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com>
	 <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de>
	 <Pine.LNX.4.64.0705031917150.2956@scrub.home>
	 <d120d5000705031217h64db0644qb1e8bc8d8af6e78c@mail.gmail.com>
	 <Pine.LNX.4.64.0705032124020.1479@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Thu, 3 May 2007, Dmitry Torokhov wrote:
>
> > > I explained already at a earlier occasion, why this "generic" keycode
> > > thing is broken by design, which makes connecting multiple keyboards with
> > > different mappings impossible.
> > >
> >
> > No, I don't think so. Your points were:
> >
> > 1) You did not want to adjust your legacy keymap on Amiga
>
> Adjusting wouldn't be really a problem, if it had some value...
>
> > 2) You want userspace programs to know how to program scancodes for
> > every type of keyboard and have different keymaps for different type
> > of keyboards (So you need to have n_kbd_types *
> > n_international_mappings keymaps).
>
> I never said that. Many keyboard _types_ need a separate key mapping.
> Localization is a completely different problem (and could be solved via
> separate localization tables).
> Most of it can be solved in userspace and we wouldn't have to enumerate
> every possible single key the kernel never cares about in <linux/input.h>.
>

I am not sure that solving it all in userspace is right solution.
Consider a sleep button. It can be hooked up via ACPI, located on AT
keyboard, USB keyboard or even on a remote control or some userspace
daemon getting data from the network. If kernel just passes raw data
to userspace then userspace programs need to know all these potential
sources and handle them separately. But with unified input device
interface userspace program only needs to monotor appearance of new
event devices, latch onto them and wait for EV_KEY/KEY_SLEEP. And it
is not much burden for the kernel because kernel already interfaces
with all these devices. In fact there probably savings because kernel
uses single interface layer.

> > As far as 2) goes I think it is better to have unified keyboard map
> > across different types of keyboards and then overlay
> > internatinalization/other settings. And you still have per-keyboard
> > configurability as you can change scancode->keycode mapping on a
> > per-device basis via evdev ioctl.
>
> You still completely ignore the problem of how said application should
> properly support multiple keyboard mappings...
>

I am afraid this statement is too vague, we need to discuss specific
scenarios...

Consider this scenario:

You use 2 PS/2 keyboards with your laptop - built-in and external one
on a separate serio port. Your built-in has media keys generating some
non-standard scancodes. The external one also has same media keys but
generating different set of keycodes. With unified input events you
can "fix" your keboards to generate same input events and the rest of
your stack does not care.

-- 
Dmitry
