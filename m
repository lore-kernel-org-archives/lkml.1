Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZLIO7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZLIO7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZLIO7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:59:14 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39396 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbZLIO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:59:14 -0500
Date: Wed, 9 Dec 2009 14:59:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Questions about Watch Dog Timer under Linux.
Message-ID: <20091209145919.GH9018@sirena.org.uk>
References: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
X-Cookie: Include me out.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 10:47:28PM +0800, Cypher Wu wrote:
> I'm used to work on embedded systems, the Watch Dog Timer in our
> products is usually a seperate chip on the board wich will start to
> work after power reset and will time out in 2 seconds. The system has
> to start dog clearing from the very beginning and there have no way to
> disable WDT.

> Now I want to use WDT under Linux, while I read
> Documentation/watchdog/watchdog-api.txt and then look though some
> drivers of WDT under Linux, it seems WDT under Linux has to be able to
> be disabled, and it will be disabled from the beginning, and starting
> to work after the application open the special driver file?  The
> sample code under Linux use a very bigger time span than our embedded
> system:

You don't *have* to be able to disable the watchdog - the API supports
it but you can always fail to do so (and even where you can Linux
watchdogs support a non-disabling mode, look for WATCHDOG_NOWAYOUT in
existing drivers).  Similarly, there's no problem with having the
watchdog be live at system startup - if the watchdog is already enabled
when the driver is opened then the driver just needs to handle that
gracefully.

> 	while (1) {
> 		ret = write(fd, "\0", 1);

...

> 		sleep(10);
> 	}
> 

> Is this the pattern we have to follow to use WDT under Linux? We have

You're free to update the watchdog as often as you like, the 10s is
just a number that was picked which is suitable for that application.

> to choose a chip as WDT, and it seems the chip we've familiar under
> embedded systems can't be used under Linux?

Nothing about your watchdog sounds particularly unusual for Linux.
