Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbXJQWVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbXJQWVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbXJQWVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:21:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57812 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880AbXJQWVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:21:16 -0400
Date: Thu, 18 Oct 2007 00:21:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       adaplas@gmail.com
Subject: Re: [PATCH] vc bell config
Message-ID: <20071017222114.GE2156@elf.ucw.cz>
References: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr> <20071011181137.GA3868@ucw.cz> <Pine.LNX.4.64.0710171820570.28622@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710171820570.28622@fbirervta.pbzchgretzou.qr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> It is already possible to deactivate the vc bell on a per-tty basis,
> >> by using echo -en "\e[11;0]", but this is reset on reset(1).
> >> 
> >> This adds a sysfs parameter to globally control the vc bell, as well
> >> as sysfs parameters for default pitch and duration.
> >> 
> >> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> >
> >There are more parameters that should be set during reset... like
> >cursor size and color, palette, .... What about /sys/.../string_to_interpret
> >_on_reset ?
> 
> On reset(1), cursor size, palette, and bell parameters _do_ get reset
> to the defaults. Some defaults may already be changed by the user,
> like palette or default_utf8.
> 
> Bell configuration is currently not one of them so, should a program
> decide to reset the tty, or should it happen that your output is
> garbled (forcing you to do reset), some settings change back to
> "unwanted defaults".

Ok, and I'm suggesting general method for the "unwanted defaults"
problem. Just have a /sys/.../terminal_init_string.

During reset, let console code interpret terminal_init_string, to set
_wanted_ defaults. So you'd do:

echo -en "\e[11;0]" > /sys/.../terminal_init_string... and I'd do
something similar with softcursor settings. (Which are currently reset
to compiled-in defaults, and that is "unwanted defaults" to me).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
