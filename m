Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZGUQTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZGUQTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZGUQTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:19:33 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:47068 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZGUQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:19:32 -0400
Date: Tue, 21 Jul 2009 18:19:28 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721161928.GD13236@buzzloop.caiaq.de>
References: <20090721004531.1036d9af@lxorguk.ukuu.org.uk> <Pine.LNX.4.44L0.0907211141180.2652-100000@iolanthe.rowland.org> <20090721171625.6e2c54e4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721171625.6e2c54e4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 05:16:25PM +0100, Alan Cox wrote:
> > I got something similar with a pl2303 device, though not a crash.  I 
> > plugged in the device, opened /dev/ttyUSB0, unplugged the device, then 
> > tried to read from the open file descriptor.  The read provoked this:
> 
> That looks like it occurs after the read, however that trace shows the
> close() method being called off sys_close() which in turn means a hang up
> didn't occur when it was unplugged.

It was, at least in my case. Did some printk debugging and it showed
that the hangup callback was entered what freed the serial device.

> > This is only a lockdep warning, and I don't understand its
> > significance.  Even worse, when I plugged in a USB flash drive
> > afterward this appeared:
> 
> Looks like something freed the resources but didn't hang up when the
> disconnect occurred

Probably the real fix would be to let the tty layer know the device died
from the hangup handler.

