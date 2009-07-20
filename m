Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZGTV6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZGTV6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZGTV6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:58:46 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:56469 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbZGTV6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:58:45 -0400
Date: Mon, 20 Jul 2009 23:58:41 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oneukum@suse.de>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090720215841.GJ19257@buzzloop.caiaq.de>
References: <20090720155502.50b84ae9@lxorguk.ukuu.org.uk> <1248112313-7842-1-git-send-email-daniel@caiaq.de> <20090720234829.1b32b2c0@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720234829.1b32b2c0@t61.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 11:48:29PM +0100, Alan Cox wrote:
> > The reason is that the serial port's resources are freed upon
> > disconnect (in serial_hangup()) but the tty device layer is not made
> > aware of that. Hence, the close callback will later access the
> > resources again.
> 
> tty_port_hangup() is part of the hangup path and the physical resources
> should not be touched after the hangup completes. It's a good
> indication of where the bug might be but its not I suspect the fix as
> we now leak the resources.

Depends on how you define the time of removal. The user space connection
stays open after the device was removed. And it is closed once the tty
layer finds out that it can't write to the hardware anymore. Once you
try to bring the tty to life, all resources are freed.

At least, this patch fixes a serious oops.

Daniel

