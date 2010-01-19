Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398Ab0ASPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab0ASPZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766Ab0ASPZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:25:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63548 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0ASPZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:25:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nlku3fWAqlowBp02ymiVaiiU7afbZ9kPjooQnBKxVtHRuduCSMaHmLEOPn4dcKh61B
         HZdDljcTkcIuG87X/btLVEpOvZb140inI/RqCuRbYHO0lVAqiLbQ+9ugVAGzLt+TuFjM
         WrdKufK9ntSeUi/1T5u+dPBUgeCdtwMvP+RRc=
Date: Tue, 19 Jan 2010 16:25:36 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
 writes" causes gobi_loader to hang
Message-ID: <20100119152536.GA2104@localhost>
References: <20100117025535.GB7045@srcf.ucam.org>
 <201001191420.29652.oliver@neukum.org>
 <20100119132934.0c1688f7@lxorguk.ukuu.org.uk>
 <201001191457.00504.oliver@neukum.org>
 <20100119142657.02856d15@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119142657.02856d15@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The log shows no call to usb_serial_generic_write_room()
> > Do you consider this a bug in the tty layer?
> 
> Actually this all makes sense because of where it was hanging. A reply of
> 0 to the tty->ops->write will cause it to either return (O_NONBLOCK) or
> sleep in the n_tty write code waiting for a write_wait wakeup
> (tty_wakeup(tty))
> 
> So the fix does indeed look correct.

Is it really a fix? If the fifo is already full the write urb should be
in use and Oliver's patch would amount to only a minor optimisation as
usb_serial_generic_write_start would return 0 anyway.

/Johan

