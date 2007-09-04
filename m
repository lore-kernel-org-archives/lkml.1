Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbXIDVLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbXIDVLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 17:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXIDVLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 17:11:04 -0400
Received: from brick.kernel.dk ([87.55.233.238]:6419 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbXIDVLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 17:11:03 -0400
Date: Tue, 4 Sep 2007 23:06:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: Micah Gruber <micah.gruber@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de
Subject: Re: [PATCH] Fix a potential NULL pointer dereference in
	usbat_check_status()  in drivers/usb/storage/shuttle_usbat.c
Message-ID: <20070904210630.GD4117@kernel.dk>
References: <46DD1661.4070500@gmail.com> <20070904110651.GB5126@kernel.dk> <1188935869.19079.3.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1188935869.19079.3.camel@odie.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04 2007, Simon Holm Thøgersen wrote:
> tir, 04 09 2007 kl. 13:06 +0200, skrev Jens Axboe:
> > On Tue, Sep 04 2007, Micah Gruber wrote:
> > > This patch fixes a potential null dereference bug where we dereference us before a null check. This patch simply moves the dereferencing after the null check.
> > > 
> > > Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
> > 
> > Be careful with stuff like that, if you actually look at the code, a us
> > == NULL doesn't seem to be possible (or usbat_flash_transport() would
> > have oopsed before).
> > 
> If that is true, then
>         if (!us)
>                 return USB_STOR_TRANSPORT_ERROR;
> is utterly pointless.

Well that was the point I was trying to make, that test and return
should be deleted instead.

-- 
Jens Axboe

