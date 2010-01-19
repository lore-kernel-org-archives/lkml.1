Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220Ab0ASSoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0ASSoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165Ab0ASSoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:44:15 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:40187 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0ASSoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:44:15 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Tue, 19 Jan 2010 19:44:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Johan Hovold <jhovold@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100117025535.GB7045@srcf.ucam.org> <20100119152536.GA2104@localhost> <20100119162746.04ba6d9e@lxorguk.ukuu.org.uk>
In-Reply-To: <20100119162746.04ba6d9e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001191944.54622.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Januar 2010 17:27:46 schrieb Alan Cox:
> On Tue, 19 Jan 2010 16:25:36 +0100
> Johan Hovold <jhovold@gmail.com> wrote:

> > Is it really a fix? If the fifo is already full the write urb should be
> > in use and Oliver's patch would amount to only a minor optimisation as
> > usb_serial_generic_write_start would return 0 anyway.
> 
> IF the write returns a zero then it will sleep in n_tty waiting for a
> wakeup when the FIFO level drops sufficiently. If that isn't working
> check that all cases where data is cleared from the FIFO called
> tty_wakeup and do so *after* the FIFO has been partly emptied and the
> locking has ensured the space is visible to the write side.
> 
usb_serial_generic_write_bulk_callback() always calls the softint
in the single URB case. Therefore the test with the patch I sent.
It is unlikely to be chance that the hang happens just as the FIFO
is full.

	Regards
		Oliver
