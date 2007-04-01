Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbXDAPZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbXDAPZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 11:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbXDAPZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 11:25:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1170 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933452AbXDAPZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 11:25:13 -0400
Date: Sun, 1 Apr 2007 07:49:30 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [bug] hung bootup in various drivers, was: "2.6.21-rc5: known regressions"
Message-ID: <20070401074929.GA4722@ucw.cz>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330120416.GA19373@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -183,7 +183,8 @@ int driver_register(struct device_driver
>  void driver_unregister(struct device_driver * drv)
>  {
>  	bus_remove_driver(drv);
> -	wait_for_completion(&drv->unloaded);
> +	if (!drv->unloaded.done)
> +		WARN_ON(1);
>  }

WARN_ON(!done)?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
