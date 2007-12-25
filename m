Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXLYXMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXLYXMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXLYXLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:11:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40669 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751355AbXLYXLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:11:50 -0500
Date: Wed, 26 Dec 2007 00:09:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Bloch <matthew@bytemark.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Message-ID: <20071225230957.GB29030@elf.ucw.cz>
References: <fk8umh$n7o$1@ger.gmane.org> <20071222120959.475ebced@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222120959.475ebced@laptopd505.fenrus.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-12-22 12:09:59, Arjan van de Ven wrote:
> On Tue, 18 Dec 2007 17:06:24 +0000
> Matthew Bloch <matthew@bytemark.co.uk> wrote:
> 
> > Hi - I'm trying to come up with a way of thoroughly testing every byte
> > of RAM from within Linux on amd64 (so that it can be automated better
> > than using memtest86+), and came up with an idea which I'm not sure is
> > supported or practical.
> > 
> > The obvious problem with testing memory from user space is that you
> > can't mlock all of it, so the best you can do is about three quarters,
> > and hope that the rest of the memory is okay.
> 
> well... to be honest the more obvious problem will be that you won't be testing the RAM, you'll be testing the CPU's cache.. over and over again.
> 
> memtest86+ does various magic to basically bypass the caches (by disabling them ;-)...
> Doing that in a live kernel situation, and from userspace to boot...... that's... and issue.

Are you sure? I always assumed that memtest just used patterns bigger
than L1/L2 caches... ... and IIRC my celeron testing confirmed it, if
I disabled L2 cache in BIOS, memtest behave differently.

Anyway, if you can do iopl(), we may as well let you disable caches,
but you are right, that will need a kernel patch.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
