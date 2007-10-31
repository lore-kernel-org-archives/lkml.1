Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbXJaRz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbXJaRz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbXJaRzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:55:49 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11807 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbXJaRzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:55:48 -0400
Date: Wed, 31 Oct 2007 18:55:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071031175543.GB11514@kernel.dk>
References: <47274A5F.6070409@gentoo.org> <20071030153417.59b9182c@the-village.bc.nu> <47276DCA.1000808@gentoo.org> <20071030190153.373c9347@the-village.bc.nu> <47278439.4030801@gentoo.org> <20071031114958.210bd7cc@the-village.bc.nu> <20071031115754.GK5059@kernel.dk> <472872F6.70802@garzik.org> <20071031122639.GN5059@kernel.dk> <4728A7D4.8050008@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4728A7D4.8050008@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31 2007, Jeff Garzik wrote:
> Jens Axboe wrote:
> >Right, that's of course problematic... There has to be a way to recover
> >that situation though, or you can't export any user command issue
> >facility.
> 
> You cannot hope to handle all possible effects arising from an app 
> providing an invalid sg header / cdb.
> 
> Once you start talking "recovery" you are already screwed:  we are 
> talking about low-level hardware commands that are passed straight to 
> the hardware.  It is trivial to lock up hardware, brick hardware, and 
> corrupt data at that level.
> 
> 
> If this is NOT a privileged app, we must update the command validation 
> to ensure that invalid commands are not transported to the hardware.
> 
> If this is a privileged app, our work is done.  Fix the app.  We gave 
> root rope, and he took it.

Woaw, back the truck up a bit :-)

I'm talking about simple things - like asking for 8 bytes of sense data.
Simple mistakes. You cannot possibly check for everything like that in a
command filter, it's utterly impossible.

> I even venture to say that "accept anything, clean up afterwards" is 
> /impossible/ to implement, in addition to being dangerous.

Certainly, that's not what I'm talking about.

-- 
Jens Axboe

