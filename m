Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXJaQGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXJaQGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbXJaQF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:05:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56238 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbXJaQF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:05:57 -0400
Message-ID: <4728A7D4.8050008@garzik.org>
Date: Wed, 31 Oct 2007 12:05:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org> <20071030153417.59b9182c@the-village.bc.nu> <47276DCA.1000808@gentoo.org> <20071030190153.373c9347@the-village.bc.nu> <47278439.4030801@gentoo.org> <20071031114958.210bd7cc@the-village.bc.nu> <20071031115754.GK5059@kernel.dk> <472872F6.70802@garzik.org> <20071031122639.GN5059@kernel.dk>
In-Reply-To: <20071031122639.GN5059@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Right, that's of course problematic... There has to be a way to recover
> that situation though, or you can't export any user command issue
> facility.

You cannot hope to handle all possible effects arising from an app 
providing an invalid sg header / cdb.

Once you start talking "recovery" you are already screwed:  we are 
talking about low-level hardware commands that are passed straight to 
the hardware.  It is trivial to lock up hardware, brick hardware, and 
corrupt data at that level.


If this is NOT a privileged app, we must update the command validation 
to ensure that invalid commands are not transported to the hardware.

If this is a privileged app, our work is done.  Fix the app.  We gave 
root rope, and he took it.


I even venture to say that "accept anything, clean up afterwards" is 
/impossible/ to implement, in addition to being dangerous.

	Jeff


