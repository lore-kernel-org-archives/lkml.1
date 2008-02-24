Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYBXHYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYBXHYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 02:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYBXHYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 02:24:06 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51535 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751315AbYBXHYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 02:24:05 -0500
Date: Sun, 24 Feb 2008 08:24:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
Subject: Re: jffs2: -ENOSPC when truncating file?!
Message-ID: <20080224072423.GF2202@elf.ucw.cz>
References: <20080223235742.GE2202@elf.ucw.cz> <1203813368.5771.174.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203813368.5771.174.camel@shinybook.infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-02-24 09:36:07, David Woodhouse wrote:
> 
> On Sun, 2008-02-24 at 00:57 +0100, Pavel Machek wrote:
> > Hi!
> > 
> > I'm trying to free space by truncating big file, and I get:
> > 
> > root@fic-gta01:~# ls -al gps.nmea 
> > -rw-r--r--    1 root     root      2332070 Feb 19 22:13 gps.nmea
> > root@fic-gta01:~# > gps.nmea 
> > -sh: cannot create gps.nmea: No space left on device
> > root@fic-gta01:~# rm gps.nmea
> > root@fic-gta01:~# > gps.nmea
> > root@fic-gta01:~# 
> 
> You need to write a log entry indicating the new length of the file.
> There is no space for new log entries.
> 
> There is a special case for removal -- 'rm gps.nmea' would work. Perhaps
> we should add a special case for truncation too, so that it can also use
> the extra pool of free space.

Yes, that would be nice. I somehow assumed that truncate can't fail
for -ENOSPC ... I was trying to actually free some space on the
filesystem...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
