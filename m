Return-Path: <linux-kernel-owner+w=401wt.eu-S1761316AbYENFHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316AbYENFHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbYENFHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:07:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48354 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbYENFGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:06:43 -0400
Date: Tue, 13 May 2008 21:52:26 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org,
       Andrew Bird <ajb@spheresystems.co.uk>,
       Javier Marcet <javier@krausbeck.org>, Filip Aben <f.aben@option.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSO: add option hso driver
Message-ID: <20080514045226.GB5400@kroah.com>
References: <20080513215134.GC6139@kroah.com> <20080513232727.21c74bb2@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513232727.21c74bb2@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:27:27PM +0100, Alan Cox wrote:
> > Jeff, please queue this up for 2.6.27 if there are no problems that you
> > can see.  It has been in the linux-next tree for a while, and many users
> > are reporting that it is working for them.
> > 
> > Or if you feel it's ok for 2.6.26, I will not object to that either :)
> 
> Can we get it into 2.6.26 - its a driver for new hardware and the driver
> is going to get a clean up for 2.6.27 anyway.
> 
> Comments below are minor and I don't think blockers
> 
> So for the serial side
> 
> Acked-by: Alan Cox <alan@redhat.com>
> 
> 
> > +	termios = serial->tty->termios;
> 
> tty is passed why keep using serial->tty (hint: think about parallel
> hangup versus close/open)

Ick, now fixed.

> > +/* close the requested serial port */
> > +static void hso_serial_close(struct tty_struct *tty, struct file *filp)
> > +{
> > +	struct hso_serial *serial = tty->driver_data;
> > +	u8 usb_gone;
> > +
> > +	D1("Closing serial port");
> > +
> > +	/* sanity check */
> > +	if (tty == NULL || serial == NULL) {
> > +		D1("(tty == NULL || tty->driver_data == NULL)");
> > +		return;
> > +	}
> 
> tty cannot be NULL here

removed.

> > +static int hso_serial_write(struct tty_struct *tty, const unsigned char *buf,
> > +			    int count)
> > +{
> > +	struct hso_serial *serial = get_serial_by_tty(tty);
> > +	int space, tx_bytes;
> > +	unsigned long flags;
> > +
> > +	/* sanity check */
> > +	if (serial == NULL) {
> > +		printk(KERN_ERR "%s: tty or tty->driver_data is NULL\n",
> 
> Checks one thing printks another 8)

Fixed.

> > +	/* the actual setup */
> > +	spin_lock_irqsave(&serial->serial_lock, flags);
> > +	if (serial->open_count)
> > +		_hso_serial_set_termios(tty, old);
> 
> (else *tty->termios = *old_termios)

Added.

Thanks for the review, I really appreciate it.

greg k-h
