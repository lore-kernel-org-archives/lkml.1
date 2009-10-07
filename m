Return-Path: <linux-kernel-owner+w=401wt.eu-S934387AbZJGVCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387AbZJGVCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934355AbZJGVCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:02:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54019 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933855AbZJGVCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:02:09 -0400
Date: Wed, 7 Oct 2009 22:02:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Message-ID: <20091007220252.5b672399@lxorguk.ukuu.org.uk>
In-Reply-To: <200910072256.21316.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0910071434290.3051-100000@iolanthe.rowland.org>
	<200910072256.21316.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009 22:56:20 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> Am Mittwoch, 7. Oktober 2009 20:52:21 schrieb Alan Stern:
> > However in the option and sierra drivers there is a perverse path from
> > close to resume: Both their close methods call
> > usb_autopm_get_interface().  This could be removed without much
> > trouble; perhaps we should do so.
> 
> I am afraid this won't do in the long run. Some drivers will want to
> shut down devices by communicating with them in close().

drivers/serial will need a power management hook to use
tty_port_{open/close} so perhaps that can be covered for both. In the
serial case it needs to kick stuff out of PCI D3 mostly and could
probably be fudged but if USB needs it perhaps it should be explicit.

