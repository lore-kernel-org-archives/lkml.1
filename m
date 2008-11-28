Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYK1KpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYK1KpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYK1KpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:45:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47795 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYK1KpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:45:01 -0500
Date: Fri, 28 Nov 2008 11:44:59 +0100
From: Pavel Machek <pavel@suse.cz>
To: ?ric Piel <eric.piel@tremplin-utc.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, trenn@suse.de, hmh@hmh.eng.br
Subject: Re: HP accelerometer: free fall detection working, testers wanted
Message-ID: <20081128104459.GA32417@atrey.karlin.mff.cuni.cz>
References: <20081121212121.GA7222@elf.ucw.cz> <20081128082215.GA2013@elf.ucw.cz> <492FC1D0.2040408@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492FC1D0.2040408@tremplin-utc.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I got free fall detection to work -- apparently BIOS does all the
> > important stuff itself. 
> > 
> > Now... I'd like some testers. (Don't comment on code... yet. Yes, it
> > has some issues).
> >
> Hi Pavel,
> I'll try to test this weekend.
> 
> Out of curiosity, what did you change compared to the original version
> of the driver? Did you just disable the set up code?

Disable all the writes, yes.

> Also, how do you try free fall? Did you try also with the lid
> opened?

With the lid opened, too, yes. I just took the machine, then tried to
let go and catch it meter below that. (Of course I did not really let
go, but released the grip and followed...)

> > hp3dg script should do all the important things.
> :
> > --- /dev/null
> > +++ b/Documentation/hwmon/hp3dg
> :
> > +while true; do
> > +	./readaccel foo
> > +	unload 2
> > +	if cat /proc/acpi/button/lid/LID/state | grep open && cat /proc/acpi/ac_adapter/AC0/state | grep off-line; then
> > +		unload 20
> > +	fi
> > +done
> Why a special case if the lid is opened and the laptop unplugged? Is it
> a special behaviour of the hardware, or simply some kind of basic user
> behaviour guess?

Behaviour guess, HP asked for those values. Idea is that if the user
is walking with machine, park as much as possible because machine is
in danger :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
