Return-Path: <linux-kernel-owner+w=401wt.eu-S637743AbXECVDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637743AbXECVDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637736AbXECVDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:03:31 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1972 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031352AbXECVD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:03:29 -0400
Date: Thu, 3 May 2007 23:01:23 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Schmitz <schmitz@debian.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
In-Reply-To: <d120d5000705031332o444415favd3f245ccdea95bea@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705032245550.2956@scrub.home>
References: <20070501195052.390551603@mail.of.borg>  <20070501195129.842338339@mail.of.borg>
  <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com> 
 <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de> 
 <Pine.LNX.4.64.0705031917150.2956@scrub.home> 
 <d120d5000705031217h64db0644qb1e8bc8d8af6e78c@mail.gmail.com> 
 <Pine.LNX.4.64.0705032124020.1479@scrub.home>
 <d120d5000705031332o444415favd3f245ccdea95bea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 3 May 2007, Dmitry Torokhov wrote:

> > I never said that. Many keyboard _types_ need a separate key mapping.
> > Localization is a completely different problem (and could be solved via
> > separate localization tables).
> > Most of it can be solved in userspace and we wouldn't have to enumerate
> > every possible single key the kernel never cares about in <linux/input.h>.
> > 
> 
> I am not sure that solving it all in userspace is right solution.

What userspace are you talking about? There is one main user - X, for it 
and all the rest you could provide a simple input library.

> Consider a sleep button. It can be hooked up via ACPI, located on AT
> keyboard, USB keyboard or even on a remote control or some userspace
> daemon getting data from the network. If kernel just passes raw data
> to userspace then userspace programs need to know all these potential
> sources and handle them separately. But with unified input device
> interface userspace program only needs to monotor appearance of new
> event devices, latch onto them and wait for EV_KEY/KEY_SLEEP. And it
> is not much burden for the kernel because kernel already interfaces
> with all these devices. In fact there probably savings because kernel
> uses single interface layer.

If the kernel would do it properly, you would have a point...

> > You still completely ignore the problem of how said application should
> > properly support multiple keyboard mappings...
> > 
> 
> I am afraid this statement is too vague, we need to discuss specific
> scenarios...
> 
> Consider this scenario:
> 
> You use 2 PS/2 keyboards with your laptop - built-in and external one
> on a separate serio port. Your built-in has media keys generating some
> non-standard scancodes. The external one also has same media keys but
> generating different set of keycodes. With unified input events you
> can "fix" your keboards to generate same input events and the rest of
> your stack does not care.

That's not the problem. Your keycode mapping has no idea about alternative 
mappings. How does the application know that "Shift"+"2" may mean '"' or 
'@'?

bye, Roman
