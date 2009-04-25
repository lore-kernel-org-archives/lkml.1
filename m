Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZDYIR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZDYIR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZDYIRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:17:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49863 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZDYIRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:17:08 -0400
Date: Sat, 25 Apr 2009 10:16:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Wait for console to become available, ver 3
Message-ID: <20090425081657.GB2428@ucw.cz>
References: <20090417213148.GA27825@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417213148.GA27825@cuplxvomd02.corp.sa.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Parallelization to improve boot times has been successful enough that race
> conditions now exist between the init_post() open of /dev/console and
> initialization of the console device. When this occurs, opening /dev/console
> fails and any applications inherited from init have no standard in/out/error
> devices. This is expected behavior if no console device is available, but
> quite unfortunate in the case where the console is just a bit slow waking up.
> 
> Some buses, such as USB, offer no guarantees about how long it takes to
> discover devices, so there is no reliable way to distinguish between a missing
> console and a slow one.  The pragmatic approach taken in this patch is to
> wait for a while to see if a console shows up, and just go on if it doesn't.
> The default delay is 1000 msec (1 second).
> 
> There are two new command line parameters:
> consolewait		Wait forever for a console to be registered
> consoledelay=msec	Use the given number of milliseconds as the delay
> 			interval instead of the default

Could you use rootfsdelay for this? Root needs to be mounted for init
to run, so...?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
