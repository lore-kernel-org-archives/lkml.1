Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551Ab0ASN4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab0ASN4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 08:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710Ab0ASN4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 08:56:20 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:54677 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0ASN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 08:56:19 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Tue, 19 Jan 2010 14:57:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100117025535.GB7045@srcf.ucam.org> <201001191420.29652.oliver@neukum.org> <20100119132934.0c1688f7@lxorguk.ukuu.org.uk>
In-Reply-To: <20100119132934.0c1688f7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001191457.00504.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Januar 2010 14:29:34 schrieb Alan Cox:
> On Tue, 19 Jan 2010 14:20:29 +0100
> Oliver Neukum <oliver@neukum.org> wrote:
> 
> > Am Montag, 18. Januar 2010 21:14:16 schrieb Matthew Garrett:
> > 
> > > drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1565 
> > > bytes
> > > drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes 
> > > into fifo
> > > drivers/usb/serial/generic.c: usb_serial_generic_read_bulk_callback - 
> > > port 0
> > 
> > If the FIFO is full we can do nothing. Please try the attached patch.
> 
> If the FIFO is full how are we getting called - we should have throttled
> earlier if there is any flow control (including 'look no URBs' cases) ?

The log shows no call to usb_serial_generic_write_room()
Do you consider this a bug in the tty layer?

	Regards
		Oliver
