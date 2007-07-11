Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbXGKKpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbXGKKpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbXGKKpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:45:00 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:33413 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbXGKKo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:44:59 -0400
Date: Wed, 11 Jul 2007 12:46:11 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070711104611.GA16703@enneenne.com>
References: <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <1183291392.2828.17.camel@shinybook.infradead.org> <20070703094831.GA13413@enneenne.com> <1183468191.29081.17.camel@shinybook.infradead.org> <20070709131924.GM11451@enneenne.com> <1184083547.32628.4.camel@pmac.infradead.org> <20070710163839.GI32503@enneenne.com> <1184145467.17833.24.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184145467.17833.24.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 10:17:47AM +0100, David Woodhouse wrote:
> On Tue, 2007-07-10 at 18:38 +0200, Rodolfo Giometti wrote:
> > On Tue, Jul 10, 2007 at 05:05:47PM +0100, David Woodhouse wrote:
> > > 
> > > I'm sure the version with 'volatile' will also be broken then. Sounds
> > > like the right answer is to fix the locking.
> > 
> > But wish avoiding locking at all since this may delay the time stamp
> > recording. We (the LinuxPPS guys) niticed that just a single
> > instruction my degrade the time setting about 50%!
> > 
> > I avoid locking just using a pointer and setting it to a dummy
> > structure when not used... is that wrong? :-o
> 
> Almost certainly (admittedly said without looking).

Please take a look at the code. I'm quite sure that it's ok. :)

I just set a pointer to a dummy struct or a valid one. By doing like
this I don't need a lock in the irq handler since it writes always
into a valid area. At non irq time I simply use a mutex lock.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
