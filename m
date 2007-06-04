Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXFDJJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXFDJJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXFDJJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:09:46 -0400
Received: from lazybastard.de ([212.112.238.170]:55190 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbXFDJJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:09:45 -0400
Date: Mon, 4 Jun 2007 11:05:07 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: LogFS take four
Message-ID: <20070604090507.GC14823@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <200706040018.23001.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706040018.23001.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 June 2007 00:18:21 +0200, Arnd Bergmann wrote:
> On Sunday 03 June 2007, Jörn Engel wrote:
> 
> > Unchanged:
> > o error handling
> > 
> ...
> > Won't happen (unless I get convinced to do otherwise):
> > o Change LOGFS_BUG() and LOGFS_BUG_ON() to inline functions
> >   These are macros for very much the same reasons BUG() and BUG_ON() are.
> 
> I wonder how many of your LOGFS_BUG{,_ON} still remain after the
> error handling is in place to deal with broken file system contents.
> Ideally, I'd say the current LOGFS_BUG() should be replaced with
> a function that prints about the kind of error it has hit (rate-limited),
> potentially calls logfs_crash_dump(), and remounts the medium read-only,
> but _not_ call BUG().

That sounds fairly useful, actually.  Do a WARN_ON(), call
logfs_crash_dump(), remount read-only and finished.  Rate-limiting might
be unnecessary as the read-only thing already limits the rate to 1.

I like the idea.

Jörn

-- 
Fools ignore complexity.  Pragmatists suffer it.
Some can avoid it.  Geniuses remove it.
-- Perlis's Programming Proverb #58, SIGPLAN Notices, Sept.  1982
