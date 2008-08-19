Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbYHSXFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbYHSXFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYHSXFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:05:34 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:43235 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYHSXFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:05:33 -0400
Date: Wed, 20 Aug 2008 01:05:23 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Message-ID: <20080819230523.GJ21330@tekkaman>
References: <1219182612-13814-1-git-send-email-giometti@linux.it> <1219182612-13814-2-git-send-email-giometti@linux.it> <1219182612-13814-3-git-send-email-giometti@linux.it> <1219182612-13814-4-git-send-email-giometti@linux.it> <1219182612-13814-5-git-send-email-giometti@linux.it> <1219182612-13814-6-git-send-email-giometti@linux.it> <20080819225322.69f3215d@lxorguk.ukuu.org.uk> <20080819224930.GI21330@tekkaman> <20080819233857.41b756cc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819233857.41b756cc@lxorguk.ukuu.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 05/10] ldisc: new dcd_change() method for line
	disciplines.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:38:57PM +0100, Alan Cox wrote:
> On Wed, 20 Aug 2008 00:49:31 +0200
> Rodolfo Giometti <giometti@enneenne.com> wrote:
> 
> > On Tue, Aug 19, 2008 at 10:53:22PM +0100, Alan Cox wrote:
> > > > + * void (*dcd_change)(struct uart_port *port, unsigned int status,
> > > > + * 			struct timespec *ts)
> > > > + *
> > > > + *	Tells the discipline that the DCD pin has changed its status and
> > > > + *	the relative timestamp. Pointer ts can be NULL.
> > > >   */
> > > 
> > > uart_port is a specific property of a few random types of interface, pass
> > > a tty struct up. Otherwise looks fine. Might one day expand it to a more
> > > generic change type and pass info on what changed but thats a future
> > > mystery.
> > 
> > How can I get the struct uart_port pointer starting from struct
> > tty_struct one?
> 
> A tty may not even have a uart structure. Why do you need to know the
> interrupt (if such a concept even exists for the given tty) ?

If you look at patch 9
(0009-PPS-low-level-IRQ-timestamps-recording.patch) you can see that
we add a (dirty?) trick to improve PPS precision a lot: we record all
IRQ timestamps into static array and then we return those values
instead of ones passed by dcd_change()...

Maybe I can solve the problem defining dcd_change() as follow:

   void (*dcd_change)(struct tty_struct *tty, unsigned int status,
                        void *data)

and then passing the timestamp or struct uart_port pointer?

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
