Return-Path: <linux-kernel-owner+w=401wt.eu-S965110AbYEBVKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965110AbYEBVKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935734AbYEBVKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:10:14 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:47109 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935285AbYEBVKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:10:13 -0400
Date: Fri, 2 May 2008 23:09:59 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Message-ID: <20080502210959.GB8502@enneenne.com>
References: <20080411075515.GH26777@enneenne.com> <20080411092840.3cc4de67@core> <20080411134724.GF2160@csclub.uwaterloo.ca> <20080411154652.4852b6d4@core> <20080430114107.GE3002@enneenne.com> <20080430172855.6d2e81a6@core> <20080502073335.GK3002@enneenne.com> <20080502111837.588c15ae@core> <20080502104537.GW3002@enneenne.com> <20080502135618.7172af4a@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502135618.7172af4a@core>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 5/7] PPS: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 01:56:18PM +0100, Alan Cox wrote:
> > So I should rewrite the uart_handle_dcd_change() as follow?
> > 
> > static inline void
> > uart_handle_dcd_change(struct uart_port *port, unsigned int status)
> > {
> >         struct uart_info *info = port->info;
> > 	struct tty_struct *tty = info->tty;
> >         struct tty_ldisc *ld;
> > 
> >         ld = tty_ldisc_ref(tty);
> >         if (ld != NULL) {
> >                 if (ld->dcd_change)
> >                         (ld->dcd_change)(tty, port, status);
> >                 tty_ldisc_deref(ld);
> >         }
> > 
> >         port->icount.dcd++;
> > 
> > #ifdef CONFIG_HARD_PPS
> >         if ((port->flags & UPF_HARDPPS_CD) && status)
> >                 hardpps();
> > #endif
> 
> The ifdef bit can go - it will be in your dcd_change callback ..

The "#ifdef CONFIG_HARD_PPS" is currently into kernel code, is *not*
my modification at all. In fact you can find the flag UPF_HARDPPS_CD
defined into include/linux/serial_core.h. It's a part of a very old
PPS implemention (never merged into mainline) and it was used to
enable the PPS layer for serial ports. That's why I didn't define an
ldisc but implemented my PPS version using it. :)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
