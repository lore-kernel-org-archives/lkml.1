Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZG1M2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZG1M2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZG1M2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:28:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38793 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753263AbZG1M2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:28:17 -0400
Date: Tue, 28 Jul 2009 13:29:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the ttydev tree with the
 usb.current tree
Message-ID: <20090728132911.03ff78ea@lxorguk.ukuu.org.uk>
In-Reply-To: <200907281410.41449.oliver@neukum.org>
References: <20090728140110.7cfe7c22.sfr@canb.auug.org.au>
	<20090728112608.09a494e0@lxorguk.ukuu.org.uk>
	<200907281410.41449.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As serial_open() takes the lock, resume() must not do so.
> If however, remote wakeup is used a lock must be taken
> to look at port->count reliably. As this is impossible, the patch
> implementing use of remote wakeup for the option driver
> implements a private flag for opened ports.

I need to look at the actual diff, but the combination looks completely
bogus unless I'm misreading the fixup which is possible.

The way the core serial code and most other drivers do this is to keep
track of the port ASYNC_INITIALIZED flag, which indicates (in the non USB
cases but trivially fixable for the USB cases) that the port hardware is
initialized. We now set it on an open but we don't clear it on
serial_do_down() finishing.

