Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188Ab0ASPPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0ASPPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834Ab0ASPPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:15:34 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:42729 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0ASPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:15:08 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Tue, 19 Jan 2010 16:15:47 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100117025535.GB7045@srcf.ucam.org> <201001191457.00504.oliver@neukum.org> <20100119142124.6f2a7034@lxorguk.ukuu.org.uk>
In-Reply-To: <20100119142124.6f2a7034@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001191615.47589.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Januar 2010 15:21:24 schrieb Alan Cox:
> > > > If the FIFO is full we can do nothing. Please try the attached patch.
> > > 
> > > If the FIFO is full how are we getting called - we should have throttled
> > > earlier if there is any flow control (including 'look no URBs' cases) ?
> > 
> > The log shows no call to usb_serial_generic_write_room()
> > Do you consider this a bug in the tty layer?
> 
> Some of the line disciplines just throw data at the board but not n_tty
> (the normal one) - so for PPP you wouldn't see checks on room but the
> loader I assume is using the normal tty layer - if so something is up
> because the ldisc shouldn't have written more than there is room for.

I don't know which line discipline is used. Matthew?

But anyway, if this can happen buglessly, the generic function
must handle it.

	Regards
		Oliver
