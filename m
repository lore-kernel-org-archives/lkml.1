Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbXJFHfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbXJFHfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 03:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXJFHfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 03:35:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1074 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751940AbXJFHfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 03:35:47 -0400
Date: Sat, 6 Oct 2007 07:35:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chakri n <chakriin5@gmail.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: NFS on loopback locks up entire system(2.6.23-rc6)?
Message-ID: <20071006073534.GA4727@ucw.cz>
References: <92cbf19b0709201722k6265e647x31b7d25bc54b63a0@mail.gmail.com> <1190335423.6763.180.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190335423.6763.180.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I am testing NFS on loopback locks up entire system with 2.6.23-rc6 kernel.
> > 
> > I have mounted a local ext3 partition using loopback NFS (version 3)
> > and started my test program. The test program forks 20 threads
> > allocates 10MB for each thread, writes & reads a file on the loopback
> > NFS mount. After running for about 5 min, I cannot even login to the
> > machine. Commands like ps etc, hang in a live session.
> > 
> > The machine is a DELL 1950 with 4Gig of RAM, so there is plenty of RAM
> > & CPU to play around and no other io/heavy processes are running on
> > the system.
...
> > Any ideas what could potentially trigger this?
> 
> This is pretty much expected: the NFS server is trying to allocate
> memory. The VM then tries to satisfy that demand by freeing up resources
> from the NFS client by telling the client to write out cached pages. The
> client again is in a congested state in which it is waiting on the NFS
> server to finish writing out what it already sent.
> 	Quod Erat Deadlocked...

Could we add nice warning to documentation? Or make kernel
printk(ALERT) when user tries to mount 127.0.0.1 (ok, that may not be
completely foolproof). Or make server refuse connections from
localhost and syslog loudly?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
