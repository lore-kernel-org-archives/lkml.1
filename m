Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbZJGSxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbZJGSxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZJGSxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:53:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49203 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754180AbZJGSw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:52:59 -0400
Date: Wed, 7 Oct 2009 14:52:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
In-Reply-To: <20091007192507.2784266a@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0910071434290.3051-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Alan Cox wrote:

> > > It would probably be cleaner if they could lock against each other
> > 
> > What you mean isn't clear.  After all, open sometimes has to call
> > resume.  So how could resume lock against open?
> 
> Probably it needs a counting lock as the code is currently structured -
> which is a bit ugly. What paths do we end up going through the device
> open method into resume in the same thread ?

Currently there are no such paths.  I keep forgetting that the resume
is done in serial_install() rather than serial_open().  Eventually the
tty_port reorganization will probably force the resume to move into the
activate method.

However in the option and sierra drivers there is a perverse path from
close to resume: Both their close methods call
usb_autopm_get_interface().  This could be removed without much
trouble; perhaps we should do so.

Alan Stern

