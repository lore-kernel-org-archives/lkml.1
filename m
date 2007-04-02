Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbXDBFio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbXDBFio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXDBFio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:38:44 -0400
Received: from 1wt.eu ([62.212.114.60]:1609 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbXDBFin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:38:43 -0400
Date: Mon, 2 Apr 2007 07:38:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Tal Kelrich <tal@musicgenome.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.4] Watchdog wdt977 (Winbond W83977EF) driver
Message-ID: <20070402053834.GC943@1wt.eu>
References: <20070401171407.0e99d86a@shodan.orpak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070401171407.0e99d86a@shodan.orpak.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Apr 01, 2007 at 05:14:07PM +0300, Tal Kelrich wrote:
> (resent due to mailer stupidity)
> Hello,
> 
> This is my first submitted kernel patch, please be gentle.
> 
> Tested and working on AAEON GENE-6310B Subcompact Board
> (also configured for same by default, should work elsewhere)
> patch is against kernel 2.4.34.2
> 
> Changes/Features:
> 
> Added ioctl support
> Disables watchdog on driver load
> Supports timeout in seconds
> Timeout defaults to 2 minutes
> No longer under NetWinder arch
> Configurable output GP (defaults to GP16)
> Configurable base IO address
> Non standard read only proc interface for status (/proc/watchdog)
> 
> Caveats:
> 
> No idea if this breaks netwinder, although it really shouldn't
> Only tested with GP16
> Utterly ignores inability to get its IO port, mostly because it's
> already taken. I didn't know a way around that.
> release_region is called regardless of having acquired the region, this
> might be trouble.

While I have no particular problem merging your other driver since it
did not previously exist, I don't like much this one being massively
changed like this, particularly when you cannot test whether it breaks
its original platform (netwinder). I've also noticed that your patch
removes some locking, so I'm even doubting that it will not break
NetWinder.

A less risky solution would be to make a new driver of it (eg: w93977.c
instead of wdt977.c). Also, if you proceed like this, please do not
forget to write an entry in Configure.help.

Regards,
Willy

