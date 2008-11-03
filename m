Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYKCRlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYKCRlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYKCRlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:41:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4206 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYKCRlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:41:31 -0500
Date: Mon, 3 Nov 2008 17:41:16 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Dmitry <dbaryshkov@gmail.com>
Cc: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org, cbou@mail.ru,
       Andrew Morton <akpm@linux-foundation.org>,
       Sebastian Siewior <al+sa@ml.breakpoint.cc>
Message-ID: <20081103174115.GA27150@sirena.org.uk>
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com> <bc64b4640811021236t3458bf69vd1becc4ab1133be1@mail.gmail.com> <20081103145514.GA23466@oksana.dev.rtsoft.ru> <bc64b4640811030820j660b8386x39bf2285b1dba887@mail.gmail.com> <20081103162547.GA25546@oksana.dev.rtsoft.ru> <bc64b4640811030841h5bcc537fy4b645c6d293b7b46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640811030841h5bcc537fy4b645c6d293b7b46@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] power_supply: only register tosa_battery driver on tosa
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 07:41:47PM +0300, Dmitry wrote:
> 2008/11/3 Anton Vorontsov <avorontsov@ru.mvista.com>:

> > Hmm.. So you can't rename the tosa driver, because then it won't
> > work, correct?

> * write better wm97xx interface. Dunno if that is feasible or possible.
>   One of the possible solutions is to pass battery and ts device names
>   and data from within board data via ac97 layer to wm97xx-core. This
>   will provide several benefits (e.g. then we can drop lots of parameters
>   from wm97xx-core, which are really board parameters).

There's only trivial writing required to do this in the WM97xx driver
itself - all that needs to be done is to allow the existing machine data
to be passed in as platform data and then add a couple of additional
hooks to that to allow instantation of things like the battery drivers
from machine code rather than doing it unconditionally as is done now.
The blocker currently is that it's not possible to pass any platform
data to an AC97 codec.

There was some work on doing that from Sebastian Siewior (CCed) but it
doesn't look like it ever made it to mainline.  The last I saw of it[1]
it got stalled due to concerns about the difficulty in doing something
that is both type safe and general enough to cover complex cases like
the WM97xx parts that want to pass in lots of highly device and system
specific stuff.  It did go into external ALSA for at least a while,
though.

It'd be really good to see some way of getting platform data to AC97
devices.  It would make the WM97xx drivers a lot easier to use if we
could do it - I keep hoping to find the cycles to actively pursue this
myself but it's not happened yet.

[1] http://thread.gmane.org/gmane.linux.alsa.devel/52882
