Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbYK1OAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbYK1OAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 09:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYK1N7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:59:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51545 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751485AbYK1N7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:59:54 -0500
Date: Fri, 28 Nov 2008 13:58:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] ldisc: new dcd_change() method for line disciplines.
Message-ID: <20081128135837.16a09068@lxorguk.ukuu.org.uk>
In-Reply-To: <492FD864.50901@imap.cc>
References: <1227647470-4816-1-git-send-email-giometti@linux.it>
	<1227647470-4816-2-git-send-email-giometti@linux.it>
	<492FD864.50901@imap.cc>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 12:39:16 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> Rodolfo Giometti schrieb:
> > --- a/include/linux/tty_ldisc.h
> > +++ b/include/linux/tty_ldisc.h
> > @@ -99,11 +99,19 @@
> >   *	cease I/O to the tty driver. Can sleep. The driver should
> >   *	seek to perform this action quickly but should wait until
> >   *	any pending driver I/O is completed.
> > + *
> > + * void (*dcd_change)(struct uart_port *port, unsigned int status,
> > + * 			struct timespec *ts)
> > + *
> > + *	Tells the discipline that the DCD pin has changed its status and
> > + *	the relative timestamp. Pointer ts can be NULL.
> >   */
> 
> I don't see an actual call to that new method getting added anywhere.
> Is that planned for a later patch?

Its used in one of the later patches of the set.
