Return-Path: <linux-kernel-owner+w=401wt.eu-S936706AbYEBUf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936706AbYEBUf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764343AbYEBUfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:35:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46183 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbYEBUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:35:46 -0400
Date: Fri, 2 May 2008 22:35:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: Jean Delvare <khali@linux-fr.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, trenn@suse.de,
       Kasper Sandberg <lkml@metanurb.dk>, Len Brown <lenb@kernel.org>,
       Matthew <jackdachef@gmail.com>, linux-acpi@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Message-ID: <20080502203529.GD3956@ucw.cz>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <200804182151.49021.lenb@kernel.org> <200804231143.10875.maximlevitsky@gmail.com> <1209406784.11608.15.camel@localhost> <1209474423.1784.837.camel@queen.suse.de> <20080429170824.09540206@hyperion.delvare> <48179DB4.8040701@assembler.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48179DB4.8040701@assembler.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > I still need to be convinced that there is a bug here.
> 
> It is not a bug, a max limit changed too, it is just matter how to scale it. The
> temperature is non-physical so comparing it to physical temperature does not
> make any sense. I'm sorry I did not invent this relative temp stuff - Complain
> @intel. They have some calibration of TjMAX for mobiles, but this bit does not
> work for desktops/servers. I tried really hard to get at LEAST some
> documentation so the driver looks like it looks. And not
> guessed/guessed/guessed/how it looked earlier.

If absolute temperature is not known, could we move it to some
obviously invalid range, so that people would not treat it as absolute
temperature?

Like, set tjmax == 0K, and report relative temperatures below 0K? Or
move it to 100-200C range, which is obviously invalid?

Or maybe invent 'relative temperature' attribute?

> >>>> Lets at least make a kernel option to override tjmax?
> > 
> > That's a possibility for sure, but what we would really need is to
> > adjust the coretemp driver heuristics to always get it right - if
> > that's not already the case, that is. I'll let Rudolf decide anyway.
> 
> Well again, Intel swears there is no way how to get the TjMAX for
> desktops/servers. It sucks but this is not my fault.

Uff, does it differ between cpus with same stepping/etc?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
