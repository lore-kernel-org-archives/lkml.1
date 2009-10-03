Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZJCQc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZJCQc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZJCQc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:32:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39313 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746AbZJCQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:32:56 -0400
Date: Sat, 3 Oct 2009 17:33:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Johan Hovold <jhovold@gmail.com>
Cc: Johan Hovold <jhovold@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091003173324.315855ac@lxorguk.ukuu.org.uk>
In-Reply-To: <20091003140522.GA8725@localhost>
References: <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost>
	<4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
	<m163ayzevu.fsf@fess.ebiederm.org>
	<20091002084755.GA7382@localhost>
	<20091002173308.6158d734@lxorguk.ukuu.org.uk>
	<20091003114229.GB605@localhost>
	<20091003141807.1dc27e4e@lxorguk.ukuu.org.uk>
	<20091003140522.GA8725@localhost>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course -- the "with low latency set" part fell out (or, was implicit
> ;-) ). Your patch, however, still has low_latency set when it calls
> tty_flip_buffer_push and that's the problem.

I don't think it does - I removed all the low latency setting.

> How about unifying them to all use a single flag field (with two flags)
> in usb_serial_port?

May make sense.

> 
> > > +	 * The per character mucking around with sysrq path it too slow, so
> > > +	 * shortcircuit it in the 99.9999999% of cases where the USB serial is
> > > +	 * not a console anyway.
> > > +	 */
> > > +	ch = packet + 2;
> > > +	len -= 2;
> > > +	if (!port->console || !port->sysrq)
> > 
> > You need && flag == TTY_NORMAL ?
> 
> You tell me. :-) Are we interested in them unless port->console is set?

Yes - we don;t care about the sysrq but we care about error characters
being reported ot the line discipline properly.
